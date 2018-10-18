import Foundation
import TokenDWallet
import DLCryptoKit

extension KeyServerApi {
    
    // MARK: - Public -
    
    // MARK: Recover wallet
    
    /// Result model for `completion` block of `KeyServerApi.recoverWallet(...)`
    /// - Note: Typealias to `KeyServerApi.UpdatePasswordResult`
    public typealias RecoverWalletResult = UpdatePasswordResult
    
    /// Method sends request to reset wallet password using recovery seed.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.RecoverWalletResult`
    /// - Parameters:
    ///   - email: Email of associated wallet.
    ///   - recoverySeedBase32Check: Recovery seed encoded with `Base32Check` encoding.
    ///   - newPassword: New password.
    ///   - networkInfo: `NetworkInfoModel` model.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.RecoverWalletResult`
    /// - Returns: Cancellable token.
    public func recoverWallet(
        email: String,
        recoverySeedBase32Check: String,
        newPassword: String,
        networkInfo: NetworkInfoModel,
        completion: @escaping (_ result: RecoverWalletResult) -> Void
        ) -> CancellableToken {
        
        var cancellableToken = CancellableToken(request: nil)
        cancellableToken = self.requestWalletKDF(
            email: email,
            isRecovery: true,
            completion: { (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failed(.walletKDFError(error)))
                    
                case .success(let walletKDF):
                    cancellableToken.request = self.continueRecoverWalletForKDF(
                        email: email,
                        newPassword: newPassword,
                        recoverySeed: recoverySeedBase32Check,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        completion: completion
                        ).request
                }
        })
        
        return cancellableToken
    }
    
    // MARK: - Private -
    
    private func continueRecoverWalletForKDF(
        email uncheckedEmail: String,
        newPassword: String,
        recoverySeed: String,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: RecoverWalletResult) -> Void
        ) -> CancellableToken {
        
        let checkedEmail = walletKDF.kdfParams.checkedEmail(uncheckedEmail)
        
        guard
            let walletId = try? KeyPairBuilder.deriveWalletId(
                forEmail: checkedEmail,
                password: recoverySeed,
                walletKDF: walletKDF
            ) else {
                completion(.failed(.cannotDeriveEncodedWalletId))
                return CancellableToken(request: nil)
        }
        
        let base16WalletId = walletId.hexadecimal()
        
        var cancellableToken = CancellableToken(request: nil)
        cancellableToken = self.requestWallet(
            walletId: base16WalletId,
            walletKDF: walletKDF,
            completion: { [weak self] (result) in
                switch result {
                    
                case .failure(let error):
                    completion(.failed(.walletDataError(error)))
                    
                case .success(let walletData):
                    cancellableToken.request = self?.continueRecoverWalletForWalletData(
                        checkedEmail: checkedEmail,
                        newPassword: newPassword,
                        recoverySeed: recoverySeed,
                        networkInfo: networkInfo,
                        walletKDF: walletKDF,
                        walletId: base16WalletId,
                        originalAccountId: walletData.accountId,
                        completion: completion
                        ).request
                }
        })
        
        return cancellableToken
    }
    
    private func continueRecoverWalletForWalletData(
        checkedEmail: String,
        newPassword: String,
        recoverySeed: String,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        walletId: String,
        originalAccountId: String,
        completion: @escaping (_ result: RecoverWalletResult) -> Void
        ) -> CancellableToken {
        
        let recoveryKeyPair: ECDSA.KeyData
        do {
            let seedData = try Base32Check.decodeCheck(expectedVersion: .seedEd25519, encoded: recoverySeed)
            recoveryKeyPair = try ECDSA.KeyData(seed: seedData)
        } catch let error {
            completion(.failed(.cannotDeriveRecoveryKeyFromSeed(error)))
            return CancellableToken(request: nil)
        }
        
        let accountApi = self.createAccountApi(signingKey: recoveryKeyPair)
        
        var cancellableToken = CancellableToken(request: nil)
        cancellableToken = accountApi.requestSigners(
            accountId: originalAccountId,
            completion: { [weak self] (result) in
                
                let signers: [Account.Signer]
                
                switch result {
                    
                case .failure(let errors):
                    if errors.contains(status: ApiError.Status.notFound) {
                        signers = []
                    } else {
                        completion(.failed(.failedToRetriveSigners(errors)))
                        return
                    }
                    
                case .success(let responseSigners):
                    signers = responseSigners.signers
                }
                
                cancellableToken.request = self?.continueRecoverWalletForSigners(
                    checkedEmail: checkedEmail,
                    newPassword: newPassword,
                    recoverySeed: recoverySeed,
                    recoveryKeyPair: recoveryKeyPair,
                    networkInfo: networkInfo,
                    walletKDF: walletKDF,
                    walletId: walletId,
                    originalAccountId: originalAccountId,
                    signers: signers,
                    completion: completion
                    ).request
        })
        
        return cancellableToken
    }
    
    private func continueRecoverWalletForSigners(
        checkedEmail: String,
        newPassword: String,
        recoverySeed: String,
        recoveryKeyPair: ECDSA.KeyData,
        networkInfo: NetworkInfoModel,
        walletKDF: WalletKDFParams,
        walletId: String,
        originalAccountId: String,
        signers: [Account.Signer],
        completion: @escaping (_ result: RecoverWalletResult) -> Void
        ) -> CancellableToken {
        
        let sigs: [Account.Signer]
        
        if signers.count > 0 {
            sigs = signers
        } else {
            sigs = [Account.Signer(
                publicKey: originalAccountId,
                weight: 0,
                signerIdentity: 0,
                signerTypeI: 0)
            ]
        }
        
        var cancellableToken = CancellableToken(request: nil)
        cancellableToken = self.updatePasswordFor(
            email: checkedEmail,
            signingPassword: recoverySeed,
            walletId: walletId,
            originalAccountId: originalAccountId,
            networkInfo: networkInfo,
            kdf: walletKDF.kdfParams,
            signingKeyPair: recoveryKeyPair,
            accountSigners: sigs,
            newPassword: newPassword,
            completion: { (result) in
                switch result {
                    
                case .failed(let error):
                    completion(.failed(error))
                    
                case .succeeded(let info, let walletData, let newKeyPair):
                    completion(.succeeded(
                        updateInfo: info,
                        walletData: walletData,
                        newKeyPair: newKeyPair
                        )
                    )
                }
        })
        
        return cancellableToken
    }
}
