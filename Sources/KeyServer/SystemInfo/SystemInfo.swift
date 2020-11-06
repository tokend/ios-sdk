import Foundation

public struct SystemInfo: Decodable {

    public let networkPassphrase: String
    public let currentTime: Int64
    public let deviceTimeDate: Date = Date()

    public enum CodingKeys: String, CodingKey {

        case networkPassphrase
        case currentTime
    }

    public var serverTimeDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self.currentTime))
    }

    public var timeDifference: Int {
        let difference = Int(self.serverTimeDate.timeIntervalSince(self.deviceTimeDate))
        return difference
    }
}
