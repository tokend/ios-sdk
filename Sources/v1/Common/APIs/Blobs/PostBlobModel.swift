import Foundation

public struct PostBlobModel: Encodable {

    public let data: Data
}

public extension PostBlobModel {

    struct Data: Encodable {

        public let type: String
        public let attributes: Attributes
        public let relationships: Relationships
    }
}

public extension PostBlobModel.Data {

    struct Attributes: Encodable {

        public let value: String
    }
}

public extension PostBlobModel.Data {

    struct Relationships: Encodable {

        public let owner: Owner
    }
}

public extension PostBlobModel.Data.Relationships {

    struct Owner: Encodable {

        public let data: Data
    }
}

public extension PostBlobModel.Data.Relationships.Owner {

    struct Data: Encodable {

        public let id: String
    }
}
