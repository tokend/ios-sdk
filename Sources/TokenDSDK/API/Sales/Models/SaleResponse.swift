import Foundation

// MARK: - SaleResponse

public class SaleResponse: Decodable {
    
    public let baseAsset: String
    public let baseCurrentCap: Decimal
    public let baseHardCap: Decimal
    public let currentCap: Decimal
    public let defaultQuoteAsset: String
    public let details: Details
    public let endTime: Date
    public let hardCap: Decimal
    public let id: String
    public let ownerId: String
    public let pagingToken: String
    public let quoteAssets: QuoteAssets
    public let saleType: SaleType
    public let softCap: Decimal
    public let startTime: Date
    public let state: State
    public let statistics: Statistics
    
    // MARK: - Decodable
    
    public init(
        baseAsset: String,
        baseCurrentCap: Decimal,
        baseHardCap: Decimal,
        currentCap: Decimal,
        defaultQuoteAsset: String,
        details: Details,
        endTime: Date,
        hardCap: Decimal,
        id: String,
        ownerId: String,
        pagingToken: String,
        quoteAssets: QuoteAssets,
        saleType: SaleType,
        softCap: Decimal,
        startTime: Date,
        state: State,
        statistics: Statistics
        ) {
        
        self.baseAsset = baseAsset
        self.baseCurrentCap = baseCurrentCap
        self.baseHardCap = baseHardCap
        self.currentCap = currentCap
        self.defaultQuoteAsset = defaultQuoteAsset
        self.details = details
        self.endTime = endTime
        self.hardCap = hardCap
        self.id = id
        self.ownerId = ownerId
        self.pagingToken = pagingToken
        self.quoteAssets = quoteAssets
        self.saleType = saleType
        self.softCap = softCap
        self.startTime = startTime
        self.state = state
        self.statistics = statistics
    }
    
    // MARK: - Decodable
    
    public enum SaleResponseCodingKeys: String, CodingKey {
        case baseAsset
        case baseCurrentCap
        case baseHardCap
        case currentCap
        case defaultQuoteAsset
        case details
        case endTime
        case hardCap
        case id
        case ownerId
        case pagingToken
        case quoteAssets
        case saleType
        case softCap
        case startTime
        case state
        case statistics
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SaleResponseCodingKeys.self)
        
        self.baseAsset = try container.decodeString(key: .baseAsset)
        self.baseCurrentCap = try container.decodeDecimalString(key: .baseCurrentCap)
        self.baseHardCap = try container.decodeDecimalString(key: .baseHardCap)
        self.currentCap = try container.decodeDecimalString(key: .currentCap)
        self.defaultQuoteAsset = try container.decodeString(key: .defaultQuoteAsset)
        self.details = try container.decode(Details.self, forKey: .details)
        self.endTime = try container.decodeDateString(key: .endTime)
        self.hardCap = try container.decodeDecimalString(key: .hardCap)
        self.id = try container.decodeString(key: .id)
        self.ownerId = try container.decodeString(key: .ownerId)
        self.pagingToken = try container.decodeString(key: .pagingToken)
        self.quoteAssets = try container.decode(QuoteAssets.self, forKey: .quoteAssets)
        self.saleType = try container.decode(SaleType.self, forKey: .saleType)
        self.softCap = try container.decodeDecimalString(key: .softCap)
        self.startTime = try container.decodeDateString(key: .startTime)
        self.state = try container.decode(State.self, forKey: .state)
        self.statistics = try container.decode(Statistics.self, forKey: .statistics)
    }
}

// MARK: - Details

extension SaleResponse {
    
    public struct Details: Decodable {
        
        public let description: String
        public let logo: Logo
        public let name: String
        public let shortDescription: String
        public let youtubeVideoId: String?
    }
}

// MARK: - Logo

extension SaleResponse.Details {
    
    public struct Logo: Decodable {
        
        public let key: String
        public let mimeType: String?
        public let name: String?
        public let type: String?
        public let url: String? // should be used if available
    }
}

// MARK: - QuoteAssets

extension SaleResponse {
    
    public struct QuoteAssets: Decodable {
        
        public let quoteAssets: [QuoteAsset]
    }
}

// MARK: - QuoteAsset

extension SaleResponse.QuoteAssets {
    
    public class QuoteAsset: Decodable {
        
        public let asset: String
        public let currentCap: Decimal
        public let price: Decimal
        public let quoteBalanceId: String
        
        // MARK: -
        
        public init(
            asset: String,
            currentCap: Decimal,
            price: Decimal,
            quoteBalanceId: String
            ) {
            
            self.asset = asset
            self.currentCap = currentCap
            self.price = price
            self.quoteBalanceId = quoteBalanceId
        }
        
        // MARK: - Decodable
        
        public enum QuoteAssetCodingKeys: String, CodingKey {
            case asset
            case currentCap
            case price
            case quoteBalanceId
        }
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: QuoteAssetCodingKeys.self)
            
            self.asset = try container.decodeString(key: .asset)
            self.currentCap = try container.decodeDecimalString(key: .currentCap)
            self.price = try container.decodeDecimalString(key: .price)
            self.quoteBalanceId = try container.decodeString(key: .quoteBalanceId)
        }
    }
}

// MARK: - SaleType

extension SaleResponse {
    
    public struct SaleType: Decodable {
        
        public let value: Int
        
        public var saleTypeValue: SaleTypeValue {
            return SaleTypeValue(rawValue: self.value) ?? .basic
        }
        
        public enum SaleTypeValue: Int {
            case basic          = 1
            case crowdFunding   = 2
            case fixedPrice     = 3
        }
    }
}

// MARK: - State

extension SaleResponse {
    
    public struct State: Decodable {
        
        public let value: Int
        
        public var stateValue: StateValue {
            return StateValue(rawValue: self.value) ?? .closed
        }
        
        public enum StateValue: Int {
            case opened     = 1
            case closed     = 2
            case canceled   = 4
        }
    }
}

// MARK: - Statistics

extension SaleResponse {
    
    public struct Statistics: Decodable {
        
        public let investors: Int
    }
}
