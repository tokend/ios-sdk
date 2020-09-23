import Foundation
import DLJSONAPI

// MARK: - InvitationsHistoryResource

open class InvitationsHistoryResource: Resource {

    open override class var resourceType: String {
        return "invitation-events"
    }

    public enum CodingKeys: String, CodingKey {
        // attributes
        case invitationType = "type"
        case details
        case signature
        case createdAt

        //relationships
        case aggregate
    }

    // MARK: Attributes

    open var invitationType: TypeStruct {
        get { return self.codableOptionalValue(key: CodingKeys.invitationType) ?? .init(value: 0, name: "") }
        set { self.setCodableOptionalValue(newValue, key: CodingKeys.invitationType) }
    }

    open var details: [String: Any] {
        get { return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:] }
        set { self.setDictionaryOptionalValue(newValue, key: CodingKeys.details)}
    }

    open var signature: String {
        get { return self.stringOptionalValue(key: CodingKeys.signature) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.signature) }
    }

    open var createdAt: String {
        get { return self.stringOptionalValue(key: CodingKeys.createdAt) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.createdAt) }
    }

    // MARK: Relationships

    open var aggregate: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.aggregate)
    }
}

public extension InvitationsHistoryResource {

    struct TypeStruct: Codable {

        public let value: Int32
        public let name: String
    }
}

// MARK: -

public extension InvitationsHistoryResource {

    enum EventType: Int32 {

        case create     = 0
        case unpaid     = 1
        case redeem     = 2
        case accept     = 3
        case cancel     = 4
        case wait       = 5
        case upcoming   = 6
        case expired    = 7
        case ended      = 8
        case arrived    = 9
        case postponed  = 10
        case authorized = 11
        case rejected   = 12
        case exited     = 13
    }
}
