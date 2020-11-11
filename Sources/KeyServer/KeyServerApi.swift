import Foundation
import DLCryptoKit
import TokenDWallet

/// Allows to send Key Server related requests.
public class KeyServerApi {
    
    // MARK: - Public properties
    
    public let apiConfiguration: ApiConfiguration
    public let requestBuilder: KeyServerApiRequestBuilder
    public let network: NetworkFacade
    public let networkV3: JSONAPI.NetworkFacade
    
    let tfaHandler: TFAHandler
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        callbacks: ApiCallbacks,
        verifyApi: TFAVerifyApi,
        requestSigner: JSONAPI.RequestSignerProtocol,
        network: NetworkProtocol,
        networkV3: JSONAPI.NetworkProtocol
        ) {
        
        self.apiConfiguration = apiConfiguration
        self.requestBuilder = KeyServerApiRequestBuilder(
            apiConfiguration: apiConfiguration,
            network: networkV3
        )
        self.tfaHandler = TFAHandler(
            callbacks: callbacks,
            verifyApi: verifyApi
        )
        self.network = NetworkFacade(network: network)
        self.networkV3 = JSONAPI.NetworkFacade(network: networkV3)
    }
    
    // MARK: - Public -
    
    // MARK: Login
    
    /// Result model for `completion` block of `KeyServerApi.loginWith(...)`
    public enum LoginRequestResult {
        
        /// Errors that may occur for `KeyServerApi.loginWith(...)`
        public enum LoginError: Swift.Error, LocalizedError {
            
            /// Failed to decode keychain data from wallet data.
            case cannotDecodeKeychainData
            
            /// Failed to derive key pair from wallet data.
            case cannotDeriveKeyPair
            
            /// Failed to derive wallet id from wallet KDF params.
            case cannotDeriveWalletId
            
            /// Failed to fetch wallet data from api.
            case requestWalletError(RequestWalletResult.RequestWalletError)
            
            /// Failed to fetch wallet KDF params from api.
            case walletKDFError(RequestWalletKDFResult.RequestError)

            case swiftError(Swift.Error)
            
            // MARK: - Swift.Error
            
            public var errorDescription: String? {
                switch self {
                case .cannotDecodeKeychainData:
                    return "Cannot decode keychain data"
                case .cannotDeriveKeyPair:
                    return "Cannot derive key pair"
                case .cannotDeriveWalletId:
                    return "Cannot derive wallet id"
                case .requestWalletError(let error):
                    return error.localizedDescription
                case .walletKDFError(let error):
                    return error.localizedDescription
                case .swiftError(let error):
                    return error.localizedDescription
                }
            }
        }
        
        /// Case of successful response from api with `WalletDataModel` and `ECDSA.KeyData` models
        case success(walletData: WalletDataModel, keyPairs: [ECDSA.KeyData])
        
        /// Case of failed response from api with `KeyServerApi.LoginRequestResult.LoginError` model
        case failure(LoginError)
    }
    
    /// Method sends request to get wallet data from api and decypher private key.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.LoginRequestResult`
    /// - Parameters:
    ///   - login: Login of associated wallet.
    ///   - password: Password to decypher private key.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.LoginRequestResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func loginWith(
        login: String,
        password: String,
        completion: @escaping (_ result: LoginRequestResult) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        cancellable = self.requestWalletKDF(
            login: login,
            completion: { [weak self] (result) in
                switch result {
                
                case .success(let walletKDF):
                    cancellable.cancelable = self?.continueLoginForKDF(
                        login: login,
                        password: password,
                        walletKDF: walletKDF,
                        completion: completion
                    )

                case .failure(let error):
                    completion(.failure(.swiftError(error)))
                }
            })
        return cancellable
    }

    /// Method sends request to get wallet data from api and decypher private key.
    /// The result of request will be fetched in `completion` block as `KeyServerApi.LoginRequestResult`
    /// - Parameters:
    ///   - login: Login of associated wallet.
    ///   - password: Password to decypher private key.
    ///   - walletKDF: Wallet key derivation function params.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `KeyServerApi.LoginRequestResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func loginWith(
        login: String,
        password: String,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: LoginRequestResult) -> Void
    ) -> Cancelable {

        return continueLoginForKDF(
            login: login,
            password: password,
            walletKDF: walletKDF,
            completion: completion
        )
    }
    
    // MARK: - Private
    
    @discardableResult
    private func continueLoginForKDF(
        login: String,
        password: String,
        walletKDF: WalletKDFParams,
        completion: @escaping (_ result: LoginRequestResult) -> Void
        ) -> Cancelable {
        
        let login = walletKDF.kdfParams.checkedLogin(login)
        
        guard
            let walletId = try? KeyPairBuilder.deriveWalletId(
                forLogin: login,
                password: password,
                walletKDF: walletKDF
            ) else {
                completion(.failure(.cannotDeriveWalletId))
                return self.network.getEmptyCancelable()
        }
        
        let base16WalletId = walletId.hexadecimal()
        
        return self.requestWallet(
            walletId: base16WalletId,
            walletKDF: walletKDF,
            completion: { [weak self] result in
                switch result {
                    
                case .success(let walletData):
                    self?.continueLoginForWalletData(
                        login: login,
                        password: password,
                        walletKDF: walletKDF,
                        walletData: walletData,
                        completion: completion
                    )
                    
                case .failure(let error):
                    completion(.failure(.requestWalletError(error)))
                }
        })
    }
    
    private func continueLoginForWalletData(
        login: String,
        password: String,
        walletKDF: WalletKDFParams,
        walletData: WalletDataModel,
        completion: @escaping (_ result: LoginRequestResult) -> Void
        ) {
        
        guard
            let keychainData = walletData.keychainData.dataFromBase64
            else {
                completion(.failure(.cannotDecodeKeychainData))
                return
        }
        
        guard let keyPairs: [ECDSA.KeyData] = try? KeyPairBuilder.getKeyPairs(
            forLogin: login,
            password: password,
            keychainData: keychainData,
            walletKDF: walletKDF
            ) else {
                completion(.failure(.cannotDeriveKeyPair))
                return
        }
        
        completion(.success(walletData: walletData, keyPairs: keyPairs))
    }
}
