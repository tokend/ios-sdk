import Foundation
import DLCryptoKit

public class SignUpRequestBuilder {
    
    // MARK: - Private properties
    
    public let keyServerApi: KeyServerApi
    
    // MARK: -
    
    public init(
        keyServerApi: KeyServerApi,
        keyValueApi: KeyValuesApiV3
    ) {

        self.keyServerApi = keyServerApi
    }
    
    // MARK: - Public
    
    public func buildSignUpRequest(
        login: String,
        password: String,
        defaultSignerRole: UInt64,
        completion: @escaping (Result) -> Void
        ) {
        
        guard let masterKeyPair = try? ECDSA.KeyData(),
            let recoveryKeyPair = try? ECDSA.KeyData(),
            let passwordFactorKeyPair = try? ECDSA.KeyData() else {
                completion(.failure(.failedToGenerateKeyPair))
                return
        }
        
        self.keyServerApi.requestDefaultKDF { [weak self] (result) in
            switch result {
                
            case .failure(let error):
                completion(.failure(.walletKDFError(error)))
                
            case .success(let kdfParams):
                self?.finishRequestCreation(
                    login: login,
                    password: password,
                    keyPair: masterKeyPair,
                    recoveryKeyPair: recoveryKeyPair,
                    passwordFactorKeyPair: passwordFactorKeyPair,
                    defaultSignerRole: defaultSignerRole,
                    referrerAccountId: nil,
                    kdfParams: kdfParams,
                    completion: completion
                )
            }
        }
    }
    
    // MARK: - Private
    
    private func finishRequestCreation(
        login: String,
        password: String,
        keyPair: ECDSA.KeyData,
        recoveryKeyPair: ECDSA.KeyData,
        passwordFactorKeyPair: ECDSA.KeyData,
        defaultSignerRole: UInt64,
        referrerAccountId: String?,
        kdfParams: KDFParams,
        completion: @escaping (Result) -> Void
        ) {
        
        let keychainParams = WalletInfoBuilder.KeychainParams(
            newKeyPair: keyPair,
            recoveryKeyPair: recoveryKeyPair,
            passwordFactorKeyPair: passwordFactorKeyPair
        )

        let createRegistrationInfoResult = WalletInfoBuilder.createWalletInfo(
            login: login,
            password: password,
            kdfParams: kdfParams,
            keychainParams: keychainParams,
            defaultSignerRole: defaultSignerRole,
            transaction: nil,
            referrerAccountId: referrerAccountId
        )
        
        switch createRegistrationInfoResult {
            
        case .failed(let error):
            completion(.failure(.registrationInfoError(error)))
            
        case .succeeded(let walletInfo):
            let walletKDF = WalletKDFParams(
                kdfParams: kdfParams,
                salt: keychainParams.newKeyPairSalt
            )
            
            completion(.success(
                login: login,
                recoveryKey: recoveryKeyPair,
                walletInfo: walletInfo,
                walletKDF: walletKDF
                )
            )
        }
    }
}

extension SignUpRequestBuilder {
    
    public enum Result {
        
        public enum CreateWalletError: Swift.Error, LocalizedError {
            
            case failedToGenerateKeyPair
            case failedToGeneratePasswordFactorKeyPair
            case failedToGenerateRecoveryKeyPair
            case registrationInfoError(WalletInfoBuilder.CreateResult.CreateError)
            case walletKDFError(KeyServerApi.RequestDefaultKDFResult.RequestError)
            
            public var errorDescription: String? {
                switch self {
                    
                case .failedToGenerateKeyPair:
                    return "Failed to generate key pair"
                    
                case .failedToGeneratePasswordFactorKeyPair:
                    return "Failed to generate password factor key pair"
                    
                case .failedToGenerateRecoveryKeyPair:
                    return "Failed to generate recovery key pair"
                    
                case .registrationInfoError(let error):
                    return error.localizedDescription
                    
                case .walletKDFError(let error):
                    return error.localizedDescription
                }
            }
        }
        
        case failure(CreateWalletError)
        
        case success(
            login: String,
            recoveryKey: ECDSA.KeyData,
            walletInfo: WalletInfoModel,
            walletKDF: WalletKDFParams
        )
    }
}
