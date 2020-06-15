import DLJSONAPI

class ManualResources {
    
    public static let resources: [Resource.Type] = [
        BusinessResource.self,
        PaymentAccountResource.self,
        AtomicSwapBuyResource.self,
        UserInfoResource.self
    ]
}
