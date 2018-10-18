import Foundation

public struct OperationsEmbedded {
    
    public let records: [OperationResponseBase]
}

extension OperationsEmbedded: Decodable {
    enum OperationsEmbeddedCodingKeys: String, CodingKey {
        case records
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OperationsEmbeddedCodingKeys.self)
        
        guard let recordsData = try container.decodeArrayIfPresent(
            [Any].self,
            forKey: .records) as? [JSON] else {
                throw DecodingError.dataCorruptedError(
                    forKey: OperationsEmbeddedCodingKeys.records,
                    in: container,
                    debugDescription: "No records"
                )
        }
        
        let recordDecoder = JSONCoders.camelCaseDecoder
        let records: [OperationResponseBase] = recordsData.compactMap { (recordData) -> OperationResponseBase? in
            guard let unified = try? OperationResponseUnified.decode(
                from: recordData,
                decoder: recordDecoder
                ) else {
                    print("unparsed json: \(recordData)")
                    return nil
            }
            
            guard let base = OperationResponseBase.init(from: unified) else {
                print("failed to init base: \(recordData)")
                return nil
            }
            
            guard let type = unified.typeValue.typeOfOperation else {
                print("unknown operation type: \(unified.type)(\(unified.typeI))")
                return base
            }
            
            if let decodedOperations = type.init(from: unified) {
                return decodedOperations
            } else {
                return base
            }
        }
        
        self.records = records
    }
}

private typealias DecodableOperationResponse = OperationResponseBase
private extension OperationResponseUnified.OperationType {
    var typeOfOperation: DecodableOperationResponse.Type? {
        switch self {
        case .unknown:
            return nil
        case .payment:
            return PaymentOperationResponse.self
        case .createIssuanceRequest:
            return CreateIssuanceRequestResponse.self
        case .createWithdrawalRequest:
            return CreateWithdrawalRequest.self
        case .checkSaleState:
            return CheckSaleStateOperationResponse.self
        case .manageOffer:
            return ManageOfferOperationResponse.self
        case .paymentv2:
            return PaymentV2OperationResponse.self
        }
    }
}
