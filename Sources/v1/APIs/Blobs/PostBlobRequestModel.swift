import Foundation

public struct PostBlobRequestModel: Encodable {

    public let type: String
    public let attributes: Attributes
    public let relationships: Relationships
}

public extension PostBlobRequestModel {

    struct Attributes: Encodable {

        public let value: String
    }
}

public extension PostBlobRequestModel {

    struct Relationships: Encodable {

        public let owner: Owner
    }
}

public extension PostBlobRequestModel.Relationships {

    struct Owner: Encodable {

        public let data: Data
    }
}

public extension PostBlobRequestModel.Relationships.Owner {

    struct Data: Encodable {

        public let id: String
    }
}
