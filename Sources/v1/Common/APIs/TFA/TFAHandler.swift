import Foundation
import DLCryptoKit

/// Model that will be fetched in `completion` block of `TFAHandler.initiateTFA(...)`
public enum TFAResult {
    
    /// Case of successful response
    case success
    
    /// Case of cancelation of TFA
    case canceled
    
    /// Case of failed response with `Swift.Error`
    case failure(Swift.Error)
}

public protocol TFAHandlerProtocol {
    func initiateTFA(
        meta: TFAMetaResponse,
        completion: @escaping (_ result: TFAResult) -> Void
    )
}

/// Class provides functionality that allows to handle the process of TFA
public class TFAHandler: TFAHandlerProtocol {
    public let verifyApi: TFAVerifyApi
    public let callbacks: ApiCallbacks
    
    public init(
        callbacks: ApiCallbacks,
        verifyApi: TFAVerifyApi
        ) {
        self.callbacks = callbacks
        self.verifyApi = verifyApi
    }
    
    // MARK: - TFAHandlerProtocol
    
    enum InitiateTFAError: Swift.Error, LocalizedError {
        case noKeychainOrSalt
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .noKeychainOrSalt:
                return "No keychain or salt data provided"
            }
        }
    }
    
    /// Method initiates TFA
    ///  - Parameters:
    ///   - meta: Factor meta data
    ///   - completion: The block which is called when the result of initiation is fetched
    public func initiateTFA(
        meta: TFAMetaResponse,
        completion: @escaping (_ result: TFAResult) -> Void
        ) {
        
        let input: ApiCallbacks.TFAInput
        switch meta.factorTypeBase {
            
        case .codeBased(let metaModel):
            input = .code(type: metaModel.factorType, inputCallback: { [weak self] code in
                self?.submitTFAFactor(
                    walletId: metaModel.walletId,
                    token: metaModel.token,
                    signedToken: code,
                    factorId: metaModel.factorId,
                    completion: completion
                )
            })
            
        case .passwordBased(let metaModel):
            let tokenSignData = ApiCallbacks.TokenSignData(
                walletId: metaModel.walletId,
                keychainData: metaModel.keychainData,
                salt: metaModel.salt,
                token: metaModel.token,
                factorId: metaModel.factorId
            )
            
            input = .password(tokenSignData: tokenSignData, inputCallback: { [weak self] signedToken in
                self?.submitTFAFactor(
                    walletId: tokenSignData.walletId,
                    token: tokenSignData.token,
                    signedToken: signedToken,
                    factorId: tokenSignData.factorId,
                    completion: completion
                )
            })
        }
        
        self.callbacks.onTFARequired(input, {
            completion(.canceled)
        })
    }
    
    // MARK: - Private
    
    fileprivate func submitTFAFactor(
        walletId: String,
        token: String,
        signedToken: String,
        factorId: Int,
        completion: @escaping (_ result: TFAResult) -> Void
        ) {
        
        self.verify(
            walletId: walletId,
            token: token,
            signedToken: signedToken,
            factorId: factorId,
            completion: { (result) in
                completion(result)
        })
    }
    
    enum VerifyError: Swift.Error, LocalizedError {
        case requestEncodingFailed
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .requestEncodingFailed:
                return "Encoding failed"
            }
        }
    }
    private func verify(
        walletId: String,
        token: String,
        signedToken: String,
        factorId: Int,
        completion: @escaping (_ result: TFAResult) -> Void
        ) {
        let attributes = TFAVerifyRequest.Attributes(
            otp: signedToken,
            token: token
        )
        let tfa = TFAVerifyRequest(attributes: attributes)
        
        guard let tfaData = try? ApiDataRequest<TFAVerifyRequest, WalletInfoModel.Include>(
            data: tfa
            ).encode() else {
                completion(.failure(VerifyError.requestEncodingFailed))
                return
        }
        
        self.verifyApi.verifyTFA(
            walletId: walletId,
            factorId: factorId,
            signedTokenData: tfaData,
            completion: { result in
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors))
                    
                case .success:
                    completion(.success)
                }
        })
    }
}

public struct TFAPasswordHandler {
    let tfaHandler: TFAHandler
    
    init(tfaHandler: TFAHandler) {
        self.tfaHandler = tfaHandler
    }
    
    // MARK: - Public
    
    public enum InitiatePasswordTFAError: Swift.Error, LocalizedError {
        case keyPairDerivationFailed
        case tokenEncodingFailed
        case tokenSignFailed
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .keyPairDerivationFailed:
                return "Key pair derivation failed"
            case .tokenEncodingFailed:
                return "Token encoding failed"
            case .tokenSignFailed:
                return "Token sign failed"
            }
        }
    }
    public func initiatePasswordTFA(
        email: String,
        password: String,
        meta: TFAPasswordMetaModel,
        kdfParams: KDFParams,
        completion: @escaping (TFAResult) -> Void
        ) {
        
        let walletKDF = WalletKDFParams(
            kdfParams: kdfParams,
            salt: meta.salt
        )
        
        guard
            let keyPairs = try? KeyPairBuilder.getKeyPairs(
                forLogin: email,
                password: password,
                keychainData: meta.keychainData,
                walletKDF: walletKDF
            ),
            let keyPair = keyPairs.first
            else {
                completion(.failure(InitiatePasswordTFAError.keyPairDerivationFailed))
                return
        }

        guard let data = meta.token.data(using: .utf8) else {
            completion(.failure(InitiatePasswordTFAError.tokenEncodingFailed))
            return
        }
        
        guard let signedToken = try? ECDSA.signED25519(data: data, keyData: keyPair).base64EncodedString() else {
            completion(.failure(InitiatePasswordTFAError.tokenSignFailed))
            return
        }
        
        self.tfaHandler.submitTFAFactor(
            walletId: meta.walletId,
            token: meta.token,
            signedToken: signedToken,
            factorId: meta.factorId,
            completion: completion
        )
    }
}
