import Foundation

public struct TFACodeMetaModel {
    
    public let factorId: Int
    public let factorType: TFAMetaResponse.CodeBasedType
    public let token: String
    public let walletId: String
    
    /// Method transforms `TFAMetaResponse` model to `TFACodeMetaModel`
    public static func fromTFAMetaResponse(_ response: TFAMetaResponse) -> TFACodeMetaModel {
        return TFACodeMetaModel(
            factorId: response.factorId,
            factorType: response.codeBasedType,
            token: response.token,
            walletId: response.walletId
        )
    }
}
