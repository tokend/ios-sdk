import Foundation

// MARK: - SaleDetailsResponse

public class SaleDetailsResponse: SaleResponse {
    
    public let quoteAssetsDetailed: QuoteAssetsDetailed
    
    // MARK: -
    
    public init(
        saleResponse: SaleResponse,
        quoteAssetsDetailed: QuoteAssetsDetailed
        ) {
        
        self.quoteAssetsDetailed = quoteAssetsDetailed
        
        super.init(
            baseAsset: saleResponse.baseAsset,
            baseCurrentCap: saleResponse.currentCap,
            baseHardCap: saleResponse.baseHardCap,
            currentCap: saleResponse.currentCap,
            defaultQuoteAsset: saleResponse.defaultQuoteAsset,
            details: saleResponse.details,
            endTime: saleResponse.endTime,
            hardCap: saleResponse.hardCap,
            id: saleResponse.id,
            ownerId: saleResponse.ownerId,
            pagingToken: saleResponse.pagingToken,
            quoteAssets: saleResponse.quoteAssets,
            saleType: saleResponse.saleType,
            softCap: saleResponse.softCap,
            startTime: saleResponse.startTime,
            state: saleResponse.state,
            statistics: saleResponse.statistics
        )
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SaleResponseCodingKeys.self)
        
        self.quoteAssetsDetailed = try container.decode(QuoteAssetsDetailed.self, forKey: .quoteAssets)
        
        try super.init(from: decoder)
    }
}

// MARK: - QuoteAssets

extension SaleDetailsResponse {
    
    public struct QuoteAssetsDetailed: Decodable {
        
        public let quoteAssets: [QuoteAssetDetailed]
    }
}

// MARK: - QuoteAsset

extension SaleDetailsResponse.QuoteAssetsDetailed {
    
    public class QuoteAssetDetailed: SaleResponse.QuoteAssets.QuoteAsset {
        
        public let hardCap: Decimal
        public let totalCurrentCap: Decimal
        
        // MARK: -
        
        public init(
            quoteAsset: SaleResponse.QuoteAssets.QuoteAsset,
            totalCurrentCap: Decimal,
            hardCap: Decimal
            ) {
            
            self.totalCurrentCap = totalCurrentCap
            self.hardCap = hardCap
            
            super.init(
                asset: quoteAsset.asset,
                currentCap: quoteAsset.currentCap,
                price: quoteAsset.price,
                quoteBalanceId: quoteAsset.quoteBalanceId
            )
        }
        
        // MARK: - Decodable
        
        public enum QuoteAssetDetailedCodingKeys: String, CodingKey {
            case hardCap
            case totalCurrentCap
        }
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: QuoteAssetDetailedCodingKeys.self)
            
            self.hardCap = try container.decodeDecimalString(key: .hardCap)
            self.totalCurrentCap = try container.decodeDecimalString(key: .totalCurrentCap)
            
            try super.init(from: decoder)
        }
    }
}
