import DLJSONAPI

class ManualResources {
    
    public static var resources: [Resource.Type] {
        var resources: [Resource.Type] = [
            BusinessResource.self,
            PaymentAccountResource.self,
            AtomicSwapBuyResource.self,
            UserInfoResource.self
        ]
        
        #if TOKENDSDK_CONTOPASSAPI
        resources.append(SystemInfoResource.self)
        #endif
        
        return resources
    }
}
