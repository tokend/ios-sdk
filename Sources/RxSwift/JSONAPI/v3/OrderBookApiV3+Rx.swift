import Foundation
import DLJSONAPI
import RxSwift

extension OrderBookRequestBuilderV3: ReactiveCompatible {}

extension Reactive where Base: OrderBookRequestBuilderV3 {
    
    public func buildOffersRequest(
        baseAsset: String,
        quoteAsset: String,
        orderBookId: String = "0",
        maxEntries: Int,
        include: [String]?
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            let request = self.base.buildOffersRequest(
                baseAsset: baseAsset,
                quoteAsset: quoteAsset,
                orderBookId: orderBookId,
                maxEntries: maxEntries,
                include: include
            )
            
            event(.success(request))
            
            return Disposables.create()
        })
    }
}

extension Reactive where Base: OrderBookApiV3 {
    
    public func requestOffers(
        baseAsset: String,
        quoteAsset: String,
        orderBookId: String,
        maxEntries: Int,
        include: [String]? = nil
        ) -> Single<Document<Horizon.OrderBookResource>> {
        
        return Single<Document<Horizon.OrderBookResource>>.create(subscribe: { (event) in
            let cancelable = self.base.requestOffers(
                baseAsset: baseAsset,
                quoteAsset: quoteAsset,
                orderBookId: orderBookId,
                maxEntries: maxEntries,
                include: include,
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
