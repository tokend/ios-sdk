import Foundation
import DLJSONAPI
import RxSwift

extension OrderBookRequestBuilderV3: ReactiveCompatible {}

extension Reactive where Base: OrderBookRequestBuilderV3 {
    
    public func buildOffersRequest(
        orderBookId: String,
        filters: OrderBookRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date()
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            self.base.buildOffersRequest(
                orderBookId: orderBookId,
                filters: filters,
                include: include,
                pagination: pagination,
                sendDate: sendDate,
                completion: { (request) in
                    guard let request = request else {
                        event(.error(JSONAPIError.failedToSignRequest))
                        return
                    }
                    
                    event(.success(request))
            })
            
            return Disposables.create()
        })
    }
}

extension Reactive where Base: OrderBookApiV3 {
    
    public func requestOffers(
        orderBookId: String,
        filters: OrderBookRequestFiltersV3,
        include: [String]? = nil,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil
        ) -> Single<Document<[OrderBookEntryResource]>> {
        
        return Single<Document<[OrderBookEntryResource]>>.create(subscribe: { (event) in
            let cancelable = self.base.requestOffers(
                orderBookId: orderBookId,
                filters: filters,
                include: include,
                pagination: pagination,
                onRequestBuilt: onRequestBuilt,
                completion: { (result) in
                    switch result {
                        
                    case .failure(let error):
                        event(.error(error))
                        
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
