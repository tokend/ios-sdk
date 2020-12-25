import Foundation
import DLCryptoKit
import TokenDWallet

public extension KeyServerApi {

    typealias LoginCompletion = (_ result: Result<
        (walletData: WalletDataModel, keyPairs: [ECDSA.KeyData]),
        Swift.Error
    >) -> Void

    /// Errors that may occur for `KeyServerApi.loginWith(...)`
    enum LoginError: Swift.Error, LocalizedError {

        /// Failed to decode keychain data from wallet data.
        case cannotDecodeKeychainData

        /// Failed to derive key pair from wallet data.
        case cannotDeriveKeyPair

        /// Failed to derive wallet id from wallet KDF params.
        case cannotDeriveWalletId

        // MARK: - Swift.Error

        public var errorDescription: String? {
            switch self {

            case .cannotDecodeKeychainData:
                return "Cannot decode keychain data"

            case .cannotDeriveKeyPair:
                return "Cannot derive key pair"

            case .cannotDeriveWalletId:
                return "Cannot derive wallet id"
            }
        }
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
    func loginWith(
        login: String,
        password: String,
        completion: @escaping LoginCompletion
        ) -> Cancelable {

        var cancellable = self.network.getEmptyCancelable()
        cancellable = self.getWalletKDF(
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
                    completion(.failure(error))
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
    func loginWith(
        login: String,
        password: String,
        walletKDF: WalletKDFParams,
        completion: @escaping LoginCompletion
    ) -> Cancelable {

        return continueLoginForKDF(
            login: login,
            password: password,
            walletKDF: walletKDF,
            completion: completion
        )
    }
}

// MARK: - Private

private extension KeyServerApi {

    @discardableResult
    func continueLoginForKDF(
        login: String,
        password: String,
        walletKDF: WalletKDFParams,
        completion: @escaping LoginCompletion
        ) -> Cancelable {

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
            return self.network.getEmptyCancelable()
        }

        let base16WalletId = walletId.hexadecimal()

        return self.getWallet(
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
                completion(.failure(LoginError.cannotDecodeKeychainData))
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
