import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch offers
public class OffersRequestBuilder: BaseApiRequestBuilder {
    
    // MARK: - Public
    
    /// Builds request to send offer.
    /// - Parameters:
    ///   - accountId: Identifier of account from which offer is sended.
    ///   - parameters: Parameters of the offer.
    ///   - sendDate: Send time of request.
    /// - Returns: `OffersOffersRequest`
    public func buildOffersRequest(
        accountId: String,
        parameters: OffersOffersRequestParameters?,
        sendDate: Date
        ) -> OffersOffersRequest {
        
        let url = self.apiConfiguration.urlString.addPath("accounts").addPath(accountId).addPath("offers")
        
        let parametersEncoding: RequestParametersEncoding = .urlEncoding
        var parametersDict: RequestParameters = RequestParameters()
        
        if let isBuy = parameters?.isBuy {
            parametersDict["is_buy"] = isBuy
        }
        
        parametersDict["order"] = parameters?.order ?? "desc"
        
        if let baseAsset = parameters?.baseAsset {
            parametersDict["base_asset"] = baseAsset
        }
        
        if let quoteAsset = parameters?.quoteAsset {
            parametersDict["quote_asset"] = quoteAsset
        }
        
        if let orderBookId = parameters?.orderBookId {
            parametersDict["order_book_id"] = orderBookId
        }
        
        if let offerId = parameters?.offerId {
            parametersDict["offer_id"] = offerId
        }
        
        if let other = parameters?.other {
            parametersDict.merge(other) { (value1, _) -> Any in
                return value1
            }
        }
        
        let requestSignModel = RequestSignParametersModel(
            urlString: url,
            parameters: parametersDict,
            parametersEncoding: parametersEncoding
        )
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = OffersOffersRequest(
            url: url,
            method: .get,
            parameters: parametersDict.isEmpty ? nil : parametersDict,
            parametersEncoding: parametersEncoding,
            signedHeaders: signedHeaders
        )
        
        return request
    }
}
