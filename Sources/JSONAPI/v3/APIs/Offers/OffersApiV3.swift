import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch offers
public class OffersApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: OffersRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = OffersRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to fetch offers.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - parameters: Parameters of the offer.
    ///   - other: Other query parameters.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<OfferResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestOffers(
        filters: OffersRequestFilterV3,
        parameters: OffersRequestParametersV3?,
        other: RequestQueryParameters?,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping (_ result: RequestCollectionResult<Horizon.OfferResource>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildOffersRequest(
            filters: filters,
            parameters: parameters,
            other: other,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                onRequestBuilt?(request)
                
                cancelable.cancelable = self?.requestCollection(
                    Horizon.OfferResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
    
    /// Method sends request to fetch offer by Id.
    /// The result of request will be fetched in `completion` block
    /// - Parameters:
    ///   - offerId: Offer Id.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<OfferResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestOffer(
        offerId: String,
        completion: @escaping (_ result: RequestSingleResult<Horizon.OfferResource>) -> Void
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildOfferByIdRequest(
            offerId: offerId,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    Horizon.OfferResource.self,
                    request: request,
                    completion: completion
                )
        })
        
        return cancelable
    }
}
