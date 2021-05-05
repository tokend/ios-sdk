import Foundation
import DLCryptoKit
import TokenDWallet

public class KeyServerLoginService {
    
    public typealias LoginCompletion = (
        _ result: Result<
            (walletData: WalletDataModel, keyPairs: [ECDSA.KeyData]),
            Swift.Error
        >
    ) -> Void
    
    public let walletKDFProvider: WalletKDFProvider
    public let walletDataProvider: WalletDataProvider
    
    /// Errors that may occur for `KeyServerApi.loginWith(...)`
    enum Error: Swift.Error, LocalizedError {

        /// Failed to decode keychain data from wallet data.
        case cannotDecodeKeychainData

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .cannotDecodeKeychainData:
                return "Cannot decode keychain data"
            }
        }
    }
    
    public init(
        walletKDFProvider: WalletKDFProvider,
        walletDataProvider: WalletDataProvider
    ) {
        
        self.walletKDFProvider = walletKDFProvider
        self.walletDataProvider = walletDataProvider
    }
}

// MARK: - Private methods

private extension KeyServerLoginService {
    
    func continueLoginForKDF(
        login: String,
        password: String,
        walletKDF: WalletKDFParams,
        completion: @escaping LoginCompletion
        ) {

        let login = walletKDF.kdfParams.checkedLogin(login)

        let walletId: Data
        do {
            walletId = try KeyPairBuilder.deriveWalletId(
                forLogin: login,
                password: password,
                walletKDF: walletKDF
            )
        } catch {
            completion(.failure(error))
            return
        }

        let base16WalletId = walletId.hexadecimal()

        walletDataProvider.walletData(
            walletId: base16WalletId,
            completion: { [weak self] (result) in

                switch result {

                case .success(let response):
                    let walletData = WalletDataModel.fromResponse(response, walletKDF: walletKDF)
                    self?.continueLoginForWalletData(
                        login: login,
                        password: password,
                        walletKDF: walletKDF,
                        walletData: walletData,
                        completion: completion
                    )

                case .failure(let error):
                    completion(.failure(error))
                }
        })
    }

    func continueLoginForWalletData(
        login: String,
        password: String,
        walletKDF: WalletKDFParams,
        walletData: WalletDataModel,
        completion: @escaping LoginCompletion
        ) {

        guard
            let keychainData = walletData.keychainData.dataFromBase64
            else {
                completion(.failure(Error.cannotDecodeKeychainData))
                return
        }

        let keyPairs: [ECDSA.KeyData]
        do {
            keyPairs = try KeyPairBuilder.getKeyPairs(
                forLogin: login,
                password: password,
                keychainData: keychainData,
                walletKDF: walletKDF
            )
        } catch {
            completion(.failure(error))
            return
        }

        completion(.success((walletData: walletData, keyPairs: keyPairs)))
    }
}

// MARK: - Public methods

public extension KeyServerLoginService {
    
    /// Method sends request to get wallet data from api and decypher private key.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - login: Login of associated wallet.
    ///   - password: Password to decypher private key.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: `WalletDataModel` and keyPairs in `[ECDSA.KeyData]`
    func loginWith(
        login: String,
        password: String,
        completion: @escaping LoginCompletion
        ) {

        walletKDFProvider.walletKDF(
            login: login,
            isRecovery: false,
            completion: { [weak self] (result) in

                switch result {

                case .success(let walletKDF):
                    self?.continueLoginForKDF(
                        login: login,
                        password: password,
                        walletKDF: walletKDF,
                        completion: completion
                    )

                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }

    /// Method sends request to get wallet data from api and decypher private key.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - login: Login of associated wallet.
    ///   - password: Password to decypher private key.
    ///   - walletKDF: Wallet key derivation function params.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: `WalletDataModel` and keyPairs in `[ECDSA.KeyData]`
    func loginWith(
        login: String,
        password: String,
        walletKDF: WalletKDFParams,
        completion: @escaping LoginCompletion
    ) {

        continueLoginForKDF(
            login: login,
            password: password,
            walletKDF: walletKDF,
            completion: completion
        )
    }
}
