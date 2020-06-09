import Foundation
import DLJSONAPI
import RxSwift

extension HistoryRequestBuilderV3: ReactiveCompatible {}

extension Reactive where Base: HistoryRequestBuilderV3 {
    
    public func buildHistoryRequest(
        filters: HistoryRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date()
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            self.base.buildHistoryRequest(
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

extension Reactive where Base: HistoryApiV3 {
    
    public func requestHistory(
        filters: HistoryRequestFiltersV3,
        include: [String]? = nil,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil
        ) -> Single<Document<[Horizon.ParticipantsEffectResource]>> {
        
        return Single<Document<[Horizon.ParticipantsEffectResource]>>.create(subscribe: { (event) in
            let cancelable = self.base.requestHistory(
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
