import Foundation

public enum ReviewableRequestState: Int32 {
    case pending = 1
    case canceled = 2
    case approved = 3
    case rejected = 4
    case permanentlyRejected = 5
    case unknown = -1
}

extension ReviewableRequestResource {
    
    public var stateValue: ReviewableRequestState {
        return ReviewableRequestState(rawValue: self.stateI) ?? .unknown
    }
}
