import Foundation
import DLJSONAPI
import RxSwift

extension AssetPairsRequestBuilderV3: ReactiveCompatible {}

extension Reactive where Base: AssetPairsRequestBuilderV3 {
    
    public func buildAssetPairsRequest(sendDate: Date = Date()) -> Single<JSONAPI.RequestModel> {
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            let request = self.base.buildAssetPairsRequest(sendDate: sendDate)
            
            event(.success(request))
            
            return Disposables.create()
        })
    }
    
    public func buildAssetPairRequest(
        baseAsset: String,
        quoteAsset: String,
        sendDate: Date = Date()
        ) -> Single<JSONAPI.RequestModel> {
        
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            let request = self.base.buildAssetPairRequest(
                baseAsset: baseAsset,
                quoteAsset: quoteAsset,
                sendDate: sendDate
            )
            
            event(.success(request))
            
            return Disposables.create()
        })
    }
}

extension Reactive where Base: AssetPairsApiV3 {
    
    public func requestAssetPairs(
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil
        ) -> Single<Document<[AssetPairResource]>> {
        
        return Single<Document<[AssetPairResource]>>.create(subscribe: { (event) in
            let cancelable = self.base.requestAssetPairs(
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
    
    public func requestAssetPair(
        baseAsset: String,
        qupteAsset: String
        ) -> Single<Document<AssetPairResource>> {
        
        return Single<Document<AssetPairResource>>.create(subscribe: { (event) in
            let cancelable = self.base.requestAssetPair(
                baseAsset: baseAsset,
                qupteAsset: qupteAsset,
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
