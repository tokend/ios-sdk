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
public class TFAHandler {
    
    // MARK: - Public properties
    
    public let verifyApi: TFAVerifyApi
    public let callbacks: ApiCallbacks
    
    // MARK: -
    
    public init(
        callbacks: ApiCallbacks,
        verifyApi: TFAVerifyApi
        ) {
        self.callbacks = callbacks
        self.verifyApi = verifyApi
    }
}
    
// MARK: - TFAHandlerProtocol

extension TFAHandler: TFAHandlerProtocol {
    
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
            input = .code(
                type: metaModel.factorType,
                inputCallback: { [weak self] (code, completionClosure) in
                    self?.submitTFAFactor(
                        walletId: metaModel.walletId,
                        token: metaModel.token,
                        signedToken: code,
                        factorId: metaModel.factorId,
                        completion: { (result) in
                            completionClosure()
                            completion(result)
                        })
                })
            
        case .passwordBased(let metaModel):
            let tokenSignData = ApiCallbacks.TokenSignData(
                walletId: metaModel.walletId,
                keychainData: metaModel.keychainData,
                salt: metaModel.salt,
                token: metaModel.token,
                factorId: metaModel.factorId
            )
            
            input = .password(
                tokenSignData: tokenSignData,
                inputCallback: { [weak self] (signedToken, completionClosure) in
                    self?.submitTFAFactor(
                        walletId: tokenSignData.walletId,
                        token: tokenSignData.token,
                        signedToken: signedToken,
                        factorId: tokenSignData.factorId,
                        completion: { (result) in
                            completionClosure()
                            completion(result)
                        })
                })
        }
        
        self.callbacks.onTFARequired(input, {
            completion(.canceled)
        })
    }
}
    
// MARK: - Private methods

private extension TFAHandler {
    
    func submitTFAFactor(
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
    
    func verify(
        walletId: String,
        token: String,
        signedToken: String,
        factorId: Int,
        completion: @escaping (_ result: TFAResult) -> Void
        ) {
        
        let body = ApiDataRequest<TFAVerifyRequest, WalletInfoModelV2.Include>(
            data: .init(
                attributes: .init(
                    otp: signedToken,
                    token: token
                )
            )
        )
        
        let tfaData: Data
        do {
            tfaData = try body.encode()
        } catch {
            completion(.failure(error))
            return
        }
        
        self.verifyApi.verifyTFA(
            walletId: walletId,
            factorId: factorId,
            signedTokenData: tfaData,
            completion: { (result: Swift.Result) in
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
        
        // MARK: - Swift.Error
        
        public var errorDescription: String? {
            switch self {
            case .keyPairDerivationFailed:
                return "Key pair derivation failed"
            case .tokenEncodingFailed:
                return "Token encoding failed"
            }
        }
    }

    public func initiatePasswordTFA(
        login: String,
        password: String,
        meta: TFAPasswordMetaModel,
        kdfParams: KDFParams,
        completion: @escaping (TFAResult) -> Void
        ) {
        
        let walletKDF = WalletKDFParams(
            kdfParams: kdfParams,
            salt: meta.salt
        )
        
        let signedToken: String
        do {
            
            let keyPairs = try KeyPairBuilder.getKeyPairs(
                forLogin: login,
                password: password,
                keychainData: meta.keychainData,
                walletKDF: walletKDF
            )
            guard let keyPair = keyPairs.first
            else {
                completion(.failure(InitiatePasswordTFAError.keyPairDerivationFailed))
                return
            }
            
            guard let data = meta.token.data(using: .utf8) else {
                completion(.failure(InitiatePasswordTFAError.tokenEncodingFailed))
                return
            }
            
            signedToken = try ECDSA.signED25519(data: data, keyData: keyPair).base64EncodedString()
        } catch {
            completion(.failure(error))
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
