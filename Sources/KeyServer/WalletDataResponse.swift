import Foundation
import DLCryptoKit

public struct WalletDataResponse: Decodable {
    
    public let attributes: Attributes
    public let id: String
    public let type: String
    
    public struct Attributes: Decodable {
        
        public let accountId: String
        public let login: String
        public let keychainData: String
        public let verified: Bool
        
        public enum CodingKeys: String, CodingKey {
            case accountId
            // Backend legacy
            case login = "email"
            case keychainData
            case verified
        }
    }
}

extension WalletDataModel {
    
    public static func fromResponse(_ response: WalletDataResponse, walletKDF: WalletKDFParams) -> WalletDataModel {
        return WalletDataModel(
            login: response.attributes.login,
            accountId: response.attributes.accountId,
            walletId: response.id,
            type: response.type,
            keychainData: response.attributes.keychainData,
            walletKDF: walletKDF,
            verified: response.attributes.verified
        )
    }
}
