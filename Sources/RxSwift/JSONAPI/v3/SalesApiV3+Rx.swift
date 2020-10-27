import Foundation
import DLJSONAPI
import RxSwift

extension Reactive where Base: SalesRequestBuilderV3 {
    
    public func buildGetSalesRequest(saleId: String) -> Single<JSONAPI.RequestModel> {
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            let request = self.base.buildGetSalesRequest(saleId: saleId)
            
            event(.success(request))
            
            return Disposables.create()
        })
    }
    
    public func buildGetSalesRequest(
        filters: SalesRequestFiltersV3,
        pagination: RequestPagination
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            let request = self.base.buildGetSalesRequest(
                filters: filters,
                pagination: pagination
            )
            
            event(.success(request))
            
            return Disposables.create()
        })
    }
}

extension Reactive where Base: SalesApiV3 {
    
    public func getSale(saleId: String) -> Single<Document<Horizon.SaleResource>> {
        return Single<Document<Horizon.SaleResource>>.create(subscribe: { (event) in
            let cancelable = self.base.getSale(
                saleId: saleId,
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
    
    public func getSales(
        filters: SalesRequestFiltersV3,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil
        ) -> Single<Document<[Horizon.SaleResource]>> {
        
        return Single<Document<[Horizon.SaleResource]>>.create(subscribe: { (event) in
            let cancelable = self.base.getSales(
                filters: filters,
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
}
