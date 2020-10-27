import Foundation
import DLJSONAPI
import RxSwift

extension OffersRequestBuilderV3: ReactiveCompatible {}

extension Reactive where Base: OffersRequestBuilderV3 {
    
    public func buildOffersRequest(
        parameters: OffersRequestParametersV3?,
        other: RequestQueryParameters?,
        pagination: RequestPagination,
        sendDate: Date = Date()
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            self.base.buildOffersRequest(
                parameters: parameters,
                other: other,
                pagination: pagination,
                sendDate: sendDate,
                completion: { (request) in
                    guard let request = request else {
                        event(.failure(JSONAPIError.failedToSignRequest))
                        return
                    }
                    
                    event(.success(request))
            })
            
            return Disposables.create()
        })
    }
    
    public func buildOfferByIdRequest(
        offerId: String,
        sendDate: Date = Date()
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            self.base.buildOfferByIdRequest(
                offerId: offerId,
                sendDate: sendDate,
                completion: { (request) in
                    guard let request = request else {
                        event(.failure(JSONAPIError.failedToSignRequest))
                        return
                    }
                    
                    event(.success(request))
            })
            
            return Disposables.create()
        })
    }
}

extension Reactive where Base: OffersApiV3 {
    
    public func requestOffers(
        parameters: OffersRequestParametersV3?,
        other: RequestQueryParameters?,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil
        ) -> Single<Document<[Horizon.OfferResource]>> {
        
        return Single<Document<[Horizon.OfferResource]>>.create(subscribe: { (event) in
            let cancelable = self.base.requestOffers(
                parameters: parameters,
                other: other,
                pagination: pagination,
                onRequestBuilt: onRequestBuilt,
                completion: { (result) in
                    switch result {
                        
                    case .failure(let error):
                        event(.failure(error))
                        
                    case .success(let document):
                        event(.success(document))
                    }
            })
            
            return Disposables.create {
                cancelable.cancel()
            }
        })
    }
    
    public func requestOffer(
        offerId: String,
        completion: @escaping (_ result: RequestSingleResult<Horizon.OfferResource>) -> Void
        ) -> Single<Document<Horizon.OfferResource>> {
        
        return Single<Document<Horizon.OfferResource>>.create(subscribe: { (event) in
            let cancelable = self.base.requestOffer(
                offerId: offerId,
                completion: { (result) in
                    switch result {
                        
                    case .failure(let error):
                        event(.failure(error))
                        
                    case .success(let document):
                        event(.success(document))
                    }
            })
            
            return Disposables.create {
                cancelable.cancel()
            }
        })
    }
}
