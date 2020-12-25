import Foundation

public extension KeyServerApiRequestBuilder {

    // MARK: - Public

    /// Builds request to update wallet. Used to update password.
    /// - Parameters:
    ///   - walletId: Wallet id.
    ///   - walletInfo: Wallet info model.
    ///   - requestSigner: Entity that signs request.
    ///   - sendDate: Request send date.
    ///   - completion: Returns `UpdateWalletRequest` or nil.
    func buildPutWalletRequest(
        walletId: String,
        walletInfo: WalletInfoModelV2,
        requestSigner: JSONAPI.RequestSignerProtocol,
        sendDate: Date = Date(),
        completion: @escaping (PutWalletRequest?) -> Void
        ) {

        let baseUrl = self.apiConfiguration.urlString
        let path = walletsPath/walletId
        let url = baseUrl/path
        let method: RequestMethod = .put

        let walletData = ApiDataRequest<WalletInfoModelV2.WalletInfoData, WalletInfoModelV2.Include>(
            data: walletInfo.data,
            included: walletInfo.included
        )
        guard let walletInfoDataEncoded = try? walletData.encode() else {
            completion(nil)
            return
        }

        let requestSignModel = JSONAPI.RequestSignParametersModel(
            baseUrl: baseUrl,
            path: path,
            method: method,
            queryItems: [],
            bodyParameters: nil,
            headers: nil,
            sendDate: sendDate,
            network: self.network
        )

        requestSigner.sign(
            request: requestSignModel,
            completion: { (signedHeaders) in
                guard let signedHeaders = signedHeaders else {
                    completion(nil)
                    return
                }

                let request = PutWalletRequest(
                    url: url,
                    method: method,
                    parametersEncoding: .json,
                    registrationInfoData: walletInfoDataEncoded,
                    signedHeaders: signedHeaders
                )
                completion(request)
        })
    }
}
