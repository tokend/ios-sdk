import Foundation
import DLJSONAPI

// MARK: - InvitationsResource

open class InvitationsResource: Resource {

    open override class var resourceType: String {
        return "invitations"
    }

    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case reference
        case state
        case finalState
        case createdAt
        case updatedAt
        case acceptedAt
        case cancelledAt
        case paidAt
        case from
        case to
        case holdsAllowed
        case holdsLeft
        case waitUntil

        // relations
        case host
        case guest
        case data
        case place
    }

    // MARK: Attributes

    open var details: [String: Any] {
        get { return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:] }
        set { self.setDictionaryOptionalValue(newValue, key: CodingKeys.details) }
    }

    open var reference: String {
        get { return self.stringOptionalValue(key: CodingKeys.reference) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.reference) }
    }

    open var state: StateStruct {
        get { return self.codableOptionalValue(key: CodingKeys.state) ?? .init(value: 0, name: "") }
        set { self.setCodableOptionalValue(newValue, key: CodingKeys.state) }
    }

    open var finalState: StateStruct? {
        get { return self.codableOptionalValue(key: CodingKeys.finalState) }
        set { self.setCodableOptionalValue(newValue, key: CodingKeys.finalState) }
    }

    open var createdAt: String {
        get { return self.stringOptionalValue(key: CodingKeys.createdAt) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.createdAt) }
    }

    open var updatedAt: String? {
        get { return self.stringOptionalValue(key: CodingKeys.updatedAt) }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.updatedAt) }
    }

    open var acceptedAt: String? {
        get { return self.stringOptionalValue(key: CodingKeys.acceptedAt) }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.acceptedAt) }
    }

    open var cancelledAt: String? {
        get { return self.stringOptionalValue(key: CodingKeys.cancelledAt) }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.cancelledAt) }
    }

    open var paidAt: String? {
        get { return self.stringOptionalValue(key: CodingKeys.paidAt) }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.paidAt) }
    }

    open var from: String {
        get { return self.stringOptionalValue(key: CodingKeys.from) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.from) }
    }

    open var to: String {
        get { return self.stringOptionalValue(key: CodingKeys.to) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.to) }
    }

    open var holdsAllowed: Int32 {
        get { return self.int32OptionalValue(key: CodingKeys.holdsAllowed) ?? 0 }
        set { self.setInt32OptionalValue(newValue, key: CodingKeys.holdsAllowed) }
    }

    open var holdsLeft: Int32 {
        get { return self.int32OptionalValue(key: CodingKeys.holdsLeft) ?? 0 }
        set { self.setInt32OptionalValue(newValue, key: CodingKeys.holdsLeft) }
    }

    open var waitUntil: String? {
        get { return self.stringOptionalValue(key: CodingKeys.waitUntil) }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.waitUntil) }
    }

    // MARK: Relationships

    open var host: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.host)
    }

    open var guest: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.guest)
    }

    open var data: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.data)
    }

    open var place: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.place)
    }
}

public extension InvitationsResource {

    struct StateStruct: Codable {

        public let value: Int32
        public let name: String
    }
}

// MARK: -

public extension InvitationsResource {

    enum State: Int32 {

        case unpaid     = 0
        case upcoming   = 1
        case pending    = 2
        case waiting    = 3
        case accepted   = 4
        case cancelled  = 5
        case expired    = 6
        case ended      = 7
    }
}
