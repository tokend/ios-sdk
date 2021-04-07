import Foundation
import TokenDWallet
import DLCryptoKit

@available(*, deprecated, message: "Use project-specific update password flow")
public class UpdatePasswordRequestBuilder {
    
    // MARK: - Private properties
    
    public let keyServerApi: KeyServerApi
    
    // MARK: -
    
    public init(keyServerApi: KeyServerApi) {
        self.keyServerApi = keyServerApi
    }
    
    // MARK: - Public
    
    public func buildChangePasswordRequest(
        login: String,
        oldPassword: String,
        newPassword: String,
        onSignRequest: @escaping JSONAPI.SignRequestBlock,
        networkInfo: NetworkInfoModel,
        completion: @escaping (Result) -> Void) -> Cancelable {
        
        let cancelable = self.keyServerApi.network.getEmptyCancelable()
        
        guard let newKeyPair = try? ECDSA.KeyData(),
            let passwordFactorKeyPair = try? ECDSA.KeyData() else {
                completion(.failure(.newKeyGenerationFailed))
                return cancelable
        }
        
        cancelable.cancelable = self.keyServerApi.requestWalletKDF(
            login: login,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failure(.walletKDFError(error)))
                    
                case .success(let walletKDF):
                    cancelable.cancelable = self?.continueChangePassword(
                        login: login,
                        oldPassword: oldPassword,
                        newPassword: newPassword,
                        newKeyPair: newKeyPair,
                        onSignRequest: onSignRequest,
                        passwordFactorKeyPair: passwordFactorKeyPair,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        completion: completion
                    )
                }
        })
        
        return cancelable
    }
    
    public func buildRecoveryWalletRequest(
        login: String,
        recoverySeedBase32Check: String,
        newPassword: String,
        onSignRequest: @escaping JSONAPI.SignRequestBlock,
        networkInfo: NetworkInfoModel,
        completion: @escaping (Result) -> Void
        ) -> Cancelable {
        
        var cancelable = self.keyServerApi.network.getEmptyCancelable()
        
        guard let newKeyPair = try? ECDSA.KeyData(),
            let passwordFactorKeyPair = try? ECDSA.KeyData() else {
                
                completion(.failure(.newKeyGenerationFailed))
                return cancelable
        }
        
        cancelable = self.keyServerApi.requestWalletKDF(
            login: login,
            isRecovery: true,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failure(.walletKDFError(error)))
                    
                case .success(let walletKDF):
                    cancelable.cancelable = self.continueRecoverWalletForKDF(
                        login: login,
                        newPassword: newPassword,
                        newKeyPair: newKeyPair,
                        passwordFactorKeyPair: passwordFactorKeyPair,
                        recoverySeed: recoverySeedBase32Check,
                        onSignRequest: onSignRequest,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        completion: completion
                    )
                }
        })
        
        return cancelable
    }
    
    // MARK: - Private -
    
    // MARK: - Change
    
    private func continueChangePassword(
        login uncheckedLogin: String,
        oldPassword: String,
        newPassword: String,
        newKeyPair: ECDSA.KeyData,
        onSignRequest: @escaping JSONAPI.SignRequestBlock,
        passwordFactorKeyPair: ECDSA.KeyData,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        completion: @escaping (Result) -> Void
        ) -> Cancelable {
        
        let login = walletKDF.kdfParams.checkedLogin(uncheckedLogin)
        
        let walletId: String
        do {
            let walletIdData = try KeyPairBuilder.deriveWalletId(
                forLogin: login,
                password: oldPassword,
                walletKDF: walletKDF
            )
            walletId = walletIdData.hexadecimal()
        } catch {
            completion(.failure(.cannotDeriveEncodedWalletId))
            return self.keyServerApi.network.getEmptyCancelable()
        }
        
        let cancelable = self.keyServerApi.network.getEmptyCancelable()
        cancelable.cancelable = self.keyServerApi.requestWallet(
            walletId: walletId,
            walletKDF: walletKDF,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failure(.walletDataError(error)))
                    
                case .success(let walletData):
                    cancelable.cancelable = self?.continueChangePasswordForWalletData(
                        checkedLogin: login,
                        oldPassword: oldPassword,
                        newPassword: newPassword,
                        newKeyPair: newKeyPair,
                        onSignRequest: onSignRequest,
                        passwordFactorKeyPair: passwordFactorKeyPair,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        walletData: walletData,
                        completion: completion
                    )
                }
        })
        
        return cancelable
    }
    
    private func continueChangePasswordForWalletData(
        checkedLogin: String,
        oldPassword: String,
        newPassword: String,
        newKeyPair: ECDSA.KeyData,
        onSignRequest: @escaping JSONAPI.SignRequestBlock,
        passwordFactorKeyPair: ECDSA.KeyData,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        walletData: WalletDataModel,
        completion: @escaping (Result) -> Void
        ) -> Cancelable {
        
        guard let keychainData = walletData.keychainData.dataFromBase64 else {
            completion(.failure(.corruptedKeychainData))
            return self.keyServerApi.network.getEmptyCancelable()
        }
        
        let signingKeyPair: ECDSA.KeyData
        do {
            if let keyPair = try KeyPairBuilder.getKeyPairs(
                forLogin: checkedLogin,
                password: oldPassword,
                keychainData: keychainData,
                walletKDF: walletKDF
            ).first {
                signingKeyPair = keyPair
            } else {
                completion(.failure(.cannotDeriveOldKeyFrom(nil)))
                return self.keyServerApi.network.getEmptyCancelable()
            }
        } catch let error {
            completion(.failure(.cannotDeriveOldKeyFrom(error)))
            return self.keyServerApi.network.getEmptyCancelable()
        }
        
        let requestSigner = JSONAPI.RequestSignerBlockCaller(
            signingKey: signingKeyPair,
            accountId: walletData.accountId,
            onSignRequest: onSignRequest
        )
        
        let accountApiV3 = self.keyServerApi.createAccountsApiV3(
            requestSigner: requestSigner
        )
        
        let cancelable = self.keyServerApi.network.getEmptyCancelable()
        cancelable.cancelable = accountApiV3.requestSigners(
            accountId: walletData.accountId,
            completion: { [weak self] (result) in
                
                let signers: [Horizon.SignerResource]
                
                switch result {
                    
                case .failure(let errors):
                    if errors.contains(status: ApiError.Status.notFound) {
                        signers = []
                    } else {
                        completion(.failure(.failedToRetriveSigners(errors)))
                        return
                    }
                    
                case .success(let document):
                    guard let fetchedSigners = document.data else {
                        completion(.failure(.emptySignersDocument))
                        return
                    }
                    signers = fetchedSigners
                }
                
                self?.continueChangePasswordForSigners(
                    checkedLogin: checkedLogin,
                    newPassword: newPassword,
                    oldPassword: oldPassword,
                    newKeyPair: newKeyPair,
                    oldKeyPair: signingKeyPair,
                    requestSigner: requestSigner,
                    passwordFactorKeyPair: passwordFactorKeyPair,
                    networkInfo: networkInfo,
                    walletKDF: walletKDF,
                    walletData: walletData,
                    signers: signers,
                    completion: completion
                )
        })
        
        return cancelable
    }
    
    private func continueChangePasswordForSigners(
        checkedLogin: String,
        newPassword: String,
        oldPassword: String,
        newKeyPair: ECDSA.KeyData,
        oldKeyPair: ECDSA.KeyData,
        requestSigner: JSONAPI.RequestSignerProtocol,
        passwordFactorKeyPair: ECDSA.KeyData,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        walletData: WalletDataModel,
        signers: [Horizon.SignerResource],
        completion: @escaping (Result) -> Void
        ) {
        
        self.keyServerApi.requestDefaultSignerRoleId { [weak self] (result) in
            switch result {
                
            case .failure(let error):
                completion(.failure(.other(error)))
                
            case .success(let response):
                self?.updatePasswordFor(
                    login: checkedLogin,
                    signingPassword: oldPassword,
                    walletId: walletData.walletId,
                    originalAccountId: walletData.accountId,
                    networkInfo: networkInfo,
                    kdf: walletKDF.kdfParams,
                    signingKeyPair: oldKeyPair,
                    requestSigner: requestSigner,
                    accountSigners: signers,
                    defaultRoleId: UInt64(response.roleId),
                    newPassword: newPassword,
                    newKeyPair: newKeyPair,
                    passwordFactorKeyPair: passwordFactorKeyPair,
                    completion: completion
                )
            }
        }
    }
    
    // MARK: - Recovery
    
    private func continueRecoverWalletForKDF(
        login uncheckedLogin: String,
        newPassword: String,
        newKeyPair: ECDSA.KeyData,
        passwordFactorKeyPair: ECDSA.KeyData,
        recoverySeed: String,
        onSignRequest: @escaping JSONAPI.SignRequestBlock,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        completion: @escaping (Result) -> Void
        ) -> Cancelable {
        
        let checkedLogin = walletKDF.kdfParams.checkedLogin(uncheckedLogin)
        
        guard
            let walletId = try? KeyPairBuilder.deriveWalletId(
                forLogin: checkedLogin,
                password: recoverySeed,
                walletKDF: walletKDF
            ) else {
                completion(.failure(.cannotDeriveEncodedWalletId))
                return self.keyServerApi.network.getEmptyCancelable()
        }
        
        let base16WalletId = walletId.hexadecimal()
        
        var cancelable = self.keyServerApi.network.getEmptyCancelable()
        cancelable = self.keyServerApi.requestWallet(
            walletId: base16WalletId,
            walletKDF: walletKDF,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failure(.walletDataError(error)))
                    
                case .success(let walletData):
                    cancelable.cancelable = self?.continueRecoverWalletForWalletData(
                        checkedLogin: checkedLogin,
                        newPassword: newPassword,
                        newKeyPair: newKeyPair,
                        passwordFactorKeyPair: passwordFactorKeyPair,
                        recoverySeed: recoverySeed,
                        onSignRequest: onSignRequest,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        walletId: base16WalletId,
                        originalAccountId: walletData.accountId,
                        completion: completion
                    )
                }
        })
        
        return cancelable
    }
    
    private func continueRecoverWalletForWalletData(
        checkedLogin: String,
        newPassword: String,
        newKeyPair: ECDSA.KeyData,
        passwordFactorKeyPair: ECDSA.KeyData,
        recoverySeed: String,
        onSignRequest: @escaping JSONAPI.SignRequestBlock,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        walletId: String,
        originalAccountId: String,
        completion: @escaping (Result) -> Void
        ) -> Cancelable {
        
        let recoveryKeyPair: ECDSA.KeyData
        do {
            let seedData = try Base32Check.decodeCheck(expectedVersion: .seedEd25519, encoded: recoverySeed)
            recoveryKeyPair = try ECDSA.KeyData(seed: seedData)
        } catch let error {
            completion(.failure(.cannotDeriveRecoveryKeyFromSeed(error)))
            return self.keyServerApi.network.getEmptyCancelable()
        }
        
        let requestSigner = JSONAPI.RequestSignerBlockCaller(
            signingKey: recoveryKeyPair,
            accountId: originalAccountId,
            onSignRequest: onSignRequest
        )
        
        let accountApiV3 = self.keyServerApi.createAccountsApiV3(
            requestSigner: requestSigner
        )
        
        var cancelable = self.keyServerApi.network.getEmptyCancelable()
        cancelable = accountApiV3.requestSigners(
            accountId: originalAccountId,
            completion: { [weak self] (result) in
                
                let signers: [Horizon.SignerResource]
                
                switch result {
                    
                case .failure(let errors):
                    if errors.contains(status: ApiError.Status.notFound) {
                        signers = []
                    } else {
                        completion(.failure(.failedToRetriveSigners(errors)))
                        return
                    }
                    
                case .success(let document):
                    guard let fethedSigners = document.data else {
                        completion(.failure(.emptySignersDocument))
                        return
                    }
                    
                    signers = fethedSigners
                    
                    self?.continueRecoverWalletForSigners(
                        checkedLogin: checkedLogin,
                        newPassword: newPassword,
                        newKeyPair: newKeyPair,
                        passwordFactorKeyPair: passwordFactorKeyPair,
                        recoverySeed: recoverySeed,
                        recoveryKeyPair: recoveryKeyPair,
                        requestSigner: requestSigner,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        walletId: walletId,
                        originalAccountId: originalAccountId,
                        signers: signers,
                        completion: completion
                    )
                }
        })
        
        return cancelable
    }
    
    private func continueRecoverWalletForSigners(
        checkedLogin: String,
        newPassword: String,
        newKeyPair: ECDSA.KeyData,
        passwordFactorKeyPair: ECDSA.KeyData,
        recoverySeed: String,
        recoveryKeyPair: ECDSA.KeyData,
        requestSigner: JSONAPI.RequestSignerProtocol,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        walletId: String,
        originalAccountId: String,
        signers: [Horizon.SignerResource],
        completion: @escaping (Result) -> Void
        ) {
        
        self.keyServerApi.requestDefaultSignerRoleId { [weak self] (result) in
            
            switch result {
                
            case .failure(let error):
                completion(.failure(.other(error)))
                
            case .success(let response):
                self?.updatePasswordFor(
                    login: checkedLogin,
                    signingPassword: recoverySeed,
                    walletId: walletId,
                    originalAccountId: originalAccountId,
                    networkInfo: networkInfo,
                    kdf: walletKDF.kdfParams,
                    signingKeyPair: recoveryKeyPair,
                    requestSigner: requestSigner,
                    accountSigners: signers,
                    defaultRoleId: UInt64(response.roleId),
                    newPassword: newPassword,
                    newKeyPair: newKeyPair,
                    passwordFactorKeyPair: passwordFactorKeyPair,
                    completion: completion
                )
            }
        }
    }
    
    // MARK: - Update
    
    private func updatePasswordFor(
        login: String,
        signingPassword: String,
        walletId: String,
        originalAccountId: String,
        networkInfo: NetworkInfoModel,
        kdf: KDFParams,
        signingKeyPair: ECDSA.KeyData,
        requestSigner: JSONAPI.RequestSignerProtocol,
        accountSigners: [Horizon.SignerResource],
        defaultRoleId: UInt64,
        newPassword: String,
        newKeyPair: ECDSA.KeyData,
        passwordFactorKeyPair: ECDSA.KeyData,
        completion: @escaping (Result) -> Void
        ) {
        
        let sourceAccountIdData: Data
        do {
            sourceAccountIdData = try Base32Check.decodeCheck(
                expectedVersion: .accountIdEd25519,
                encoded: originalAccountId
            )
        } catch {
            completion(.failure(.cannotDecodeOriginalAccountIdData))
            return
        }
        
        let keychainParams = WalletInfoBuilder.KeychainParams(
            newKeyPair: newKeyPair,
            recoveryKeyPair: signingKeyPair,
            passwordFactorKeyPair: passwordFactorKeyPair
        )
        
        let sendDate = Date()
        let result = WalletInfoBuilder.createUpdatePasswordWalletInfo(
            login: login,
            kdf: kdf,
            signingKeyPair: signingKeyPair,
            sourceAccountIdData: sourceAccountIdData,
            accountSigners: accountSigners,
            defaultRoleId: defaultRoleId,
            originalAccountId: originalAccountId,
            networkInfo: networkInfo,
            newPassword: newPassword,
            keychainParams: keychainParams,
            sendDate: sendDate
        )
        
        switch result {
            
        case .failed(let createError):
            completion(.failure(.walletInfoBuilderUpdatePasswordError(createError)))
            
        case .succeeded(let walletInfo):
            let walletKDF = WalletKDFParams(
                kdfParams: kdf,
                salt: keychainParams.newKeyPairSalt
            )
            
            let components = Result.UpdatePasswordRequestComponents(
                email: login,
                walletId: walletId,
                walletInfo: walletInfo,
                requestSigner: requestSigner,
                signingPassword: signingPassword,
                walletKDF: walletKDF
            )
            completion(.success(components))
        }
    }
}

@available(*, deprecated, message: "Use project-specific update password flow")
extension UpdatePasswordRequestBuilder {
    
    public enum Result {
        
        public enum UpdateError: Swift.Error, LocalizedError {
            
            public typealias RequestError = Swift.Error & LocalizedError
            
            case cannotDecodeOriginalAccountIdData
            case cannotDeriveEncodedWalletId
            case cannotDeriveOldKeyFrom(Swift.Error?)
            case cannotDeriveRecoveryKeyFromSeed(Swift.Error)
            case corruptedKeychainData
            case emptySignersDocument
            case newKeyGenerationFailed
            case failedToRetriveSigners(Swift.Error)
            case other(Swift.Error)
            case walletDataError(KeyServerApi.RequestWalletResult.RequestWalletError)
            case walletInfoBuilderUpdatePasswordError(
                WalletInfoBuilder.CreateUpdatePasswordResult.CreateError
            )
            case walletKDFError(KeyServerApi.RequestWalletKDFResult.RequestError)
            case wrongOldPassword
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                    
                case .cannotDecodeOriginalAccountIdData:
                    return "Cannot decode original account id data"
                    
                case .cannotDeriveEncodedWalletId:
                    return "Cannot derive encoded wallet id"
                    
                case .cannotDeriveOldKeyFrom(let error):
                    return error?.localizedDescription
                    
                case .cannotDeriveRecoveryKeyFromSeed(let error):
                    return error.localizedDescription
                    
                case .corruptedKeychainData:
                    return "Corrupted keychain data"
                    
                case .newKeyGenerationFailed:
                    return "Failed to generate new key pair"
                    
                case .failedToRetriveSigners(let errors):
                    return errors.localizedDescription
                    
                case .other(let error):
                    return error.localizedDescription
                    
                case .walletDataError(let error):
                    return error.localizedDescription
                    
                case .walletInfoBuilderUpdatePasswordError(let error):
                    return error.localizedDescription
                    
                case .walletKDFError(let error):
                    return error.localizedDescription
                    
                case .wrongOldPassword:
                    return "Wrong old password"
                    
                case .emptySignersDocument:
                    return "Empty signers data"
                }
            }
        }
        
        case failure(UpdateError)
        
        public struct UpdatePasswordRequestComponents {
            
            public let email: String
            public let walletId: String
            public let walletInfo: WalletInfoModel
            public let requestSigner: JSONAPI.RequestSignerProtocol
            public let signingPassword: String
            public let walletKDF: WalletKDFParams
        }
        
        case success(UpdatePasswordRequestComponents)
    }
}
