import Foundation

// MARK: - OperationResponseUnified

public struct OperationResponseUnified {
    
    public let amount: Decimal?
    public let asset: String?
    public let destAmount: Decimal?
    public let destAsset: String?
    public let destinationFixedFee: Decimal?
    public let destinationFeeData: FeeData?
    public let destinationPaymentFee: Decimal?
    public let externalDetails: ExternalDetails?
    public let feeFixed: Decimal?
    public let feePercent: Decimal?
    public let from: String?
    public let fromBalance: String?
    public let id: UInt64
    public let identifier: String
    public let ledgerCloseTime: Date
    public let pagingToken: String
    public let participants: [Participant]?
    public let receiverBalance: String?
    public let reference: String?
    public let sender: String?
    public let sourceAccount: String?
    public let sourceFeeData: FeeData?
    public let sourceFixedFee: Decimal?
    public let sourcePaymentFee: Decimal?
    public let sourcePaysForDest: Bool?
    public let state: String
    public let subject: String?
    public let to: String?
    public let toBalance: String?
    public let type: String
    public let typeI: Int
    public let userDetails: String?
    
    // MARK: -
    
    public var amountChecked: Decimal {
        return self.amount ?? 0
    }
    
    public var participantsChecked: [Participant] {
        return self.participants ?? []
    }
    
    public var stateValue: OperationState {
        if let value = OperationState(rawValue: self.state) {
            return value
        } else if self.state == OperationState.fullyMatched {
            return .success
        } else {
            return .pending
        }
    }
    
    public var typeValue: OperationType {
        if let value = OperationType(rawValue: self.typeI) {
            return value
        } else {
            return .unknown
        }
    }
}

// MARK: - OperationType

extension OperationResponseUnified {
    
    public enum OperationType: Int, Decodable {
        case unknown                    = -1
        case payment                    = 1
        case createIssuanceRequest      = 3
        case createWithdrawalRequest    = 7
        case manageOffer                = 16
        case checkSaleState             = 20
        case paymentv2                  = 23
    }
}

// MARK: - OperationState

extension OperationResponseUnified {
    
    public enum OperationState: String {
        static let fullyMatched: String = "fully matched"
        
        case canceled
        case failed
        case pending
        case rejected
        case success
    }
}

// MARK: - FeeData

extension OperationResponseUnified {
    
    public struct FeeData {
        
        public let actualPaymentFee: Decimal
        public let actualPaymentFeeAssetCode: String
        public let fixedFee: Decimal
    }
}

// MARK: - ExternalDetails

extension OperationResponseUnified {
    
    public struct ExternalDetails: Decodable {
        
        public let address: String?
        public let cause: String?
        
        public var causeValue: Cause? {
            return Cause(rawValue: self.cause ?? "")
        }
        
        public enum Cause: String, Decodable {
            case airdrop
            case airdropForKYC = "airdrop-for-kyc"
        }
    }
}

// MARK: - Participant

extension OperationResponseUnified {
    
    public struct Participant: Decodable {
        
        public let accountId: String?
        public let balanceId: String?
        public let effects: [Effect]?
        public let nickname: String?
        
        var effectsChecked: [Effect] {
            return self.effects ?? []
        }
    }
}

// MARK: - Effect

extension OperationResponseUnified.Participant {
    
    public struct Effect: Decodable {
        
        public let baseAsset: String?
        public let isBuy: Bool
        public let matches: [Match]?
        public let quoteAsset: String?
        
        var matchesChecked: [Match] {
            return self.matches ?? []
        }
    }
}

// MARK: - Match

extension OperationResponseUnified.Participant.Effect {
    
    public struct Match {
        
        public let baseAmount: Decimal
        public let feePaid: Decimal
        public let price: Decimal
        public let quoteAmount: Decimal
    }
}

// MARK: - Decoding

// MARK: - OperationResponseUnified

extension OperationResponseUnified: Decodable {
    
    public enum OperationResponseUnifiedCodingKeys: String, CodingKey {
        case amount
        case asset
        case destAmount
        case destAsset
        case destinationFixedFee
        case destinationFeeData
        case destinationPaymentFee
        case externalDetails
        case feeFixed
        case feePercent
        case from
        case fromBalance
        case id
        case identifier
        case ledgerCloseTime
        case pagingToken
        case participants
        case receiverBalance
        case reference
        case sender
        case sourceAccount
        case sourceFeeData
        case sourceFixedFee
        case sourcePaymentFee
        case sourcePaysForDest
        case state
        case subject
        case to
        case toBalance
        case type
        case typeI
        case userDetails
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OperationResponseUnifiedCodingKeys.self)
        
        // Optionals
        
        self.amount = container.decodeOptionalDecimalString(key: .amount)
        self.asset = container.decodeOptionalString(key: .asset)
        self.destAmount = container.decodeOptionalDecimalString(key: .destAmount)
        self.destAsset = container.decodeOptionalString(key: .destAsset)
        self.destinationFixedFee = container.decodeOptionalDecimalString(key: .destinationFixedFee)
        self.destinationFeeData = container.decodeOptionalObject(FeeData.self, key: .destinationFeeData)
        self.destinationPaymentFee = container.decodeOptionalDecimalString(key: .destinationPaymentFee)
        self.externalDetails = container.decodeOptionalObject(ExternalDetails.self, key: .externalDetails)
        self.feeFixed = container.decodeOptionalDecimalString(key: .feeFixed)
        self.feePercent = container.decodeOptionalDecimalString(key: .feePercent)
        self.from = container.decodeOptionalString(key: .from)
        self.fromBalance = container.decodeOptionalString(key: .fromBalance)
        // ...
        self.participants = container.decodeOptionalObject([Participant].self, key: .participants)
        self.receiverBalance = container.decodeOptionalString(key: .receiverBalance)
        self.reference = container.decodeOptionalString(key: .reference)
        self.sender = container.decodeOptionalString(key: .sender)
        self.sourceAccount = container.decodeOptionalString(key: .sourceAccount)
        self.sourceFeeData = container.decodeOptionalObject(FeeData.self, key: .sourceFeeData)
        self.sourceFixedFee = container.decodeOptionalDecimalString(key: .sourceFixedFee)
        self.sourcePaymentFee = container.decodeOptionalDecimalString(key: .sourcePaymentFee)
        self.sourcePaysForDest = container.decodeOptionalBool(key: .sourcePaysForDest)
        // ...
        self.subject = container.decodeOptionalString(key: .subject)
        self.to = container.decodeOptionalString(key: .to)
        self.toBalance = container.decodeOptionalString(key: .toBalance)
        // ...
        self.userDetails = container.decodeOptionalString(key: .userDetails)
        
        // Required
        
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = UInt64(idString) else {
            throw DecodingError.dataCorruptedError(
                forKey: OperationResponseUnifiedCodingKeys.id,
                in: container,
                debugDescription: "Cannot get UInt64 from String \(idString)"
            )
        }
        self.id = id
        
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.ledgerCloseTime = try container.decodeDateString(key: .ledgerCloseTime)
        self.pagingToken = try container.decode(String.self, forKey: .pagingToken)
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? OperationState.pending.rawValue
        self.type = try container.decode(String.self, forKey: .type)
        self.typeI = try container.decode(Int.self, forKey: .typeI)
    }
}

// MARK: - FeeData

extension OperationResponseUnified.FeeData: Decodable {
    
    enum FeeDataCodingKeys: String, CodingKey {
        case actualPaymentFee
        case actualPaymentFeeAssetCode
        case fixedFee
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FeeDataCodingKeys.self)
        
        self.actualPaymentFee = try container.decodeDecimalString(key: .actualPaymentFee)
        self.fixedFee = try container.decodeDecimalString(key: .fixedFee)
        self.actualPaymentFeeAssetCode = try container.decode(String.self, forKey: .actualPaymentFeeAssetCode)
    }
}

// MARK: - Match

extension OperationResponseUnified.Participant.Effect.Match: Decodable {
    
    enum EffectCodingKeys: String, CodingKey {
        case baseAmount
        case feePaid
        case price
        case quoteAmount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EffectCodingKeys.self)
        
        self.baseAmount = try container.decodeDecimalString(key: .baseAmount)
        self.feePaid = try container.decodeDecimalString(key: .feePaid)
        self.price = try container.decodeDecimalString(key: .price)
        self.quoteAmount = try container.decodeDecimalString(key: .quoteAmount)
    }
}
