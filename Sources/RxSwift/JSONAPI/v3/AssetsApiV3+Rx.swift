import Foundation
import DLJSONAPI
import RxSwift

extension AssetsRequestBuilderV3: ReactiveCompatible {}

extension Reactive where Base: AssetsRequestBuilderV3 {
    
    public func buildAssetsRequest(pagination: RequestPagination) -> Single<JSONAPI.RequestModel> {
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            let request = self.base.buildAssetsRequest(pagination: pagination)
            
            event(.success(request))
            
            return Disposables.create()
        })
    }
    
    public func buildAssetByIdRequest(assetId: String) -> Single<JSONAPI.RequestModel> {
        return Single<JSONAPI.RequestModel>.create(subscribe: { (event) in
            let request = self.base.buildAssetByIdRequest(assetId: assetId)
            
            event(.success(request))
            
            return Disposables.create()
        })
    }
}

extension Reactive where Base: AssetsApiV3 {
    
    public func requestAssets(
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil
        ) -> Single<Document<[Horizon.AssetResource]>> {
        
        return Single<Document<[Horizon.AssetResource]>>.create(subscribe: { (event) in
            let cancelable = self.base.requestAssets(
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
    
    public func requestAssetById(assetId: String) -> Single<Document<Horizon.AssetResource>> {
        return Single<Document<Horizon.AssetResource>>.create(subscribe: { (event) in
            let cancelable = self.base.requestAssetById(
                assetId: assetId,
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
