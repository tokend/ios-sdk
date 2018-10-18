import Foundation

public struct HorizonError: Decodable, Swift.Error, LocalizedError, CustomDebugStringConvertible {
    
    public let status: Int
    public let type: String
    public let title: String
    public let detail: String?
    public let extras: Extras?
    
    public struct Extras: Decodable {
        
        public let envelopeXdr: String
        public let resultCodes: ResultCodes
        public let resultXdr: String
        
        public struct ResultCodes: Decodable {
            
            public let transaction: String?
            public let operations: [String]?
            public let messages: [String]?
        }
    }
    
    public static let resultCodeExtraTxFailed = "tx_failed"
    public static let resultCodeExtraTxBadAuth = "tx_bad_auth"
    
    // MARK: - Public
    
    public func enumerateExtrasResultCodesOperations(onNext: (
        _ index: Int,
        _ operation: String,
        _ message: String?
        ) -> Void) {
        
        guard let operations = self.extras?.resultCodes.operations else {
            return
        }
        
        let messages = self.extras?.resultCodes.messages ?? []
        let messagesCount = messages.count
        
        for (index, operation) in operations.enumerated() {
            let message: String? = index < messagesCount ? messages[index] : nil
            
            onNext(index, operation, message)
        }
    }
    
    // MARK: - Swift.Error
    
    public var errorDescription: String? {
        var description: String = "HorizonError>"
        
        description.append(" status: \(self.status)")
        description.append("; type: \(self.type)")
        description.append("; title: \(self.title)")
        if let detail = self.detail {
            description.append("; detail: \(detail)")
        }
        if let extras = self.extras {
            var extrasResultCodesDescription: String = ""
            
            if let transaction = extras.resultCodes.transaction {
                extrasResultCodesDescription.append(" transaction: \(transaction)")
            }
            if let messages = extras.resultCodes.messages {
                var messagesDescription: String = ""
                for message in messages {
                    if message.count > 0 {
                        messagesDescription.append("; ")
                    }
                    messagesDescription.append("\(message)")
                }
                
                if extrasResultCodesDescription.count > 0 {
                    extrasResultCodesDescription.append(";")
                }
                if messagesDescription.count > 0 {
                    extrasResultCodesDescription.append(" messages: [ \(messagesDescription) ]")
                }
            }
            
            if extrasResultCodesDescription.count > 0 {
                description.append("; extras> result codes> \(extrasResultCodesDescription)")
            }
        }
        
        return description
    }
    
    // MARK: - CustomDebugStringConvertible
    
    public var debugDescription: String {
        var fields: [String] = []
        
        fields.append("status: \(self.status)")
        fields.append("type: \(self.type)")
        fields.append("title: \(self.title)")
        if let detail = self.detail {
            fields.append("detail: \(detail)")
        }
        
        if let extras = self.extras {
            var resultCodesFields: [String] = []
            if let transaction = extras.resultCodes.transaction {
                resultCodesFields.append("transaction: \(transaction)")
            }
            if let operations = extras.resultCodes.operations {
                let valueFields = operations.enumerated().map { (index, value) -> String in
                    return "\(index): \(value)"
                }
                let valuesDescription = DebugFormattedDescription(valueFields)
                resultCodesFields.append("operations: \(DebugIndentedString(valuesDescription))")
            }
            if let messages = extras.resultCodes.messages {
                let valueFields = messages.enumerated().map { (index, value) -> String in
                    return "\(index): \(value)"
                }
                let valuesDescription = DebugFormattedDescription(valueFields)
                resultCodesFields.append("messages: \(DebugIndentedString(valuesDescription))")
            }
            let resultCodesFormattedDescription = DebugFormattedDescription(resultCodesFields)
            
            var extrasFields: [String] = []
            extrasFields.append("envelopeXdr: \(extras.envelopeXdr)")
            extrasFields.append("resultCodes: \(DebugIndentedString(resultCodesFormattedDescription))")
            let extrasFormattedDescription = DebugFormattedDescription(extrasFields)
            
            fields.append("extras: \(DebugIndentedString(extrasFormattedDescription))")
        }
        
        let description = DebugFormattedDescription(fields)
        
        return description
    }
}
