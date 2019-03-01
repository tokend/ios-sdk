import Foundation
import DLJSONAPI
import RxSwift

extension AccountsRequestBuilderV3: ReactiveCompatible {}

extension Reactive where Base: AccountsRequestBuilderV3 {
    
    public func buildAccountRequest(
        accountId: String,
        sendDate: Date = Date()
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) -> Disposable in
            self.base.buildAccountRequest(
                accountId: accountId,
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
    
    public func buildSignersRequest(
        accountId: String,
        sendDate: Date = Date()
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            self.base.buildSignersRequest(
                accountId: accountId,
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

extension Reactive where Base: AccountsApiV3 {
    
    public func requestAccount(accountId: String) -> Single<Document<AccountResource>> {
        return Single<Document<AccountResource>>.create(subscribe: { (event) in
            let cancelable = self.base.requestAccount(
                accountId: accountId,
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
    
    public func requestSigners(accountId: String) -> Single<Document<[SignerResource]>> {
        return Single<Document<[SignerResource]>>.create(subscribe: { (event) in
            let cancelable = self.base.requestSigners(
                accountId: accountId,
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
