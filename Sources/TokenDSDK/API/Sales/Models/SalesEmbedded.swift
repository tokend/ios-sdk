import Foundation

public struct SalesEmbedded<SaleListType: Decodable>: Decodable {
    
    public let records: [SaleListType]
}
