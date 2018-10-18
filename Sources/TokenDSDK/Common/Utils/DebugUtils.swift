import Foundation

// swiftlint:disable identifier_name
public func DebugFormattedDescription(_ strings: [String]) -> String {
    guard strings.count > 0 else {
        return "{}"
    }
    
    let description: String = strings.reduce("{\n") { (result, string) -> String in
        return result + DebugIndentedString(string) + "\n"
    }
    
    return description + "}"
}

public func DebugFormatted(
    base64EncodedData: String,
    title: String,
    clipOriginal: Bool = true
    ) -> String {
    
    let original = clipOriginal ? DebugClippedString(base64EncodedData) : base64EncodedData
    
    let stringDescription: String
    if let decodedData = base64EncodedData.dataFromBase64 {
        let count = decodedData.count
        stringDescription = "<DATA (\(count) bytes)>\n  original:\n    \(original)"
    } else {
        stringDescription = "<! FAILED TO DECODE DATA !>\n  original:\n    \(original)"
    }
    
    let description = "\(title): \(stringDescription)"
    
    return description
}

public func DebugFormatted(
    base64EncodedString: String,
    encoding: String.Encoding = .utf8,
    title: String,
    clipOriginal: Bool = true
    ) -> String {
    
    let original = clipOriginal ? DebugClippedString(base64EncodedString) : base64EncodedString
    
    let stringDescription: String
    if let decodedData = base64EncodedString.dataFromBase64 {
        if let string = String(data: decodedData, encoding: .utf8) {
            let count = string.count
            stringDescription = "<STRING (\(count) chars)>\n  string:\n    \(string)\n  original:\n    \(original)"
        } else {
            stringDescription = "<! FAILED TO DECODE UTF8STRING !>\n  original:\n    \(original)"
        }
    } else {
        stringDescription = "<! FAILED TO DECODE B64STRING !>\n  original:\n    \(original)"
    }
    
    let description = "\(title): \(stringDescription)"
    
    return description
}

public func DebugClippedString(_ string: String) -> String {
    guard string.count >= 20 else {
        return string
    }
    
    let clipped: String =
        string[string.startIndex ..< string.index(string.startIndex, offsetBy: 5)]
            + "..."
            + string[string.index(string.endIndex, offsetBy: -5) ..< string.endIndex]
    
    return clipped
}

public func DebugIndentedString(_ string: String) -> String {
    return string.replacingOccurrences(of: "\n", with: "\n  ")
}
// swiftlint:enable identifier_name
