import Foundation

public struct TFAPasswordMetaModel {
    
    public let factorId: Int
    public let keychainData: Data
    public let salt: Data
    public let token: String
    public let walletId: String
    
    /// Method transforms `TFAMetaResponse` model to `TFAPasswordMetaModel`
    public static func fromTFAMetaResponse(_ response: TFAMetaResponse) -> TFAPasswordMetaModel? {
        guard
            let keychainData = response.keychainData?.dataFromBase64,
            let salt = response.salt?.dataFromBase64
            else {
                return nil
        }
        
        return TFAPasswordMetaModel(
            factorId: response.factorId,
            keychainData: keychainData,
            salt: salt,
            token: response.token,
            walletId: response.walletId
        )
    }
}
