import Foundation

public struct WalletKDFParams {
    
    public let kdfParams: KDFParams
    public let salt: Data
    
    // MARK: - Public
    
    public init(
        kdfParams: KDFParams,
        salt: Data
        ) {
        
        self.kdfParams = kdfParams
        self.salt = salt
    }
    
    public static func fromResponse(_ response: GetWalletKDFResponse) -> WalletKDFParams? {
        guard let salt = response.attributes.salt.dataFromBase64 else {
            return nil
        }
        
        return WalletKDFParams(
            kdfParams: KDFParams.fromResponse(response),
            salt: salt
        )
    }
}
