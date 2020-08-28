import Foundation

public struct PostBlobModel: Encodable {

    public let type: String
    public let attributes: Attributes
    public let relationships: Relationships
}

public extension PostBlobModel {

    struct Attributes: Encodable {

        public let value: String
    }
}

public extension PostBlobModel {

    struct Relationships: Encodable {

        public let owner: Owner
    }
}

public extension PostBlobModel.Relationships {

    struct Owner: Encodable {

        public let data: Data
    }
}

public extension PostBlobModel.Relationships.Owner {

    struct Data: Encodable {

        public let id: String
    }
}
