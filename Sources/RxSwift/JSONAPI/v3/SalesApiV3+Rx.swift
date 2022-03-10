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
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date()
    ) -> Single<JSONAPI.RequestModel> {

        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            self.base.buildGetSalesRequest(
                filters: filters,
                include: include,
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
