import Foundation

public struct MintTokenRequest: Encodable {
    
    let data: Data
    let included: [Included]?
}

public extension MintTokenRequest {
    
    struct Data: Encodable {
        
        let type: String
        let attributes: Attributes
        let relationships: Relationships
    }
}

public extension MintTokenRequest {
    
    struct Attributes: Encodable {
        let ipfsUrl: String
        let assetCode: String
        let details: Details
        let senderAccountId: String
        let amount: Int64
        let mintTarget: ObjectType
        let type: ObjectType
    }
}

extension MintTokenRequest.Attributes {
    
    public struct ObjectType: Encodable {
        let name: String
        let value: Int32
        
        public init(
            name: String,
            value: Int32
        ) {
            self.name = name
            self.value = value
        }
    }
}

extension MintTokenRequest.Attributes {
    
    public struct Details: Encodable {
        let ipfsLink: String
        let logo: String
        let name: String
        let image: String
        let animationUrl: String?
        let attributes: [Attributes]
        let externalUrl: String
        let description: String?
        let medium: String?
        let dimensions: String?
        let mediaSize: Int64?
        let collaborators: String?
        let dateOrSeason: String?
        let representation: String?
        let directionsForUse: String?
        let unlockableContent: String?
        let mediaExtension: String?
        let veracityItemId: String?
        let veracityItemUrl: String?
        let veracityItemWidth: Float?
        let veracityItemHeight: Float?
        
        public init(
            ipfsLink: String,
            logo: String,
            name: String,
            image: String,
            animationUrl: String?,
            attributes: [Details.Attributes],
            externalUrl: String,
            description: String?,
            medium: String?,
            dimensions: String?,
            mediaSize: Int64?,
            collaborators: String?,
            dateOrSeason: String?,
            representation: String?,
            directionsForUse: String?,
            unlockableContent: String?,
            mediaExtension: String?,
            veracityItemId: String?,
            veracityItemUrl: String?,
            veracityItemWidth: Float?,
            veracityItemHeight: Float?
        ) {
            self.ipfsLink = ipfsLink
            self.logo = logo
            self.name = name
            self.image = image
            self.animationUrl = animationUrl
            self.attributes = attributes
            self.externalUrl = externalUrl
            self.description = description
            self.medium = medium
            self.dimensions = dimensions
            self.mediaSize = mediaSize
            self.collaborators = collaborators
            self.dateOrSeason = dateOrSeason
            self.representation = representation
            self.directionsForUse = directionsForUse
            self.unlockableContent = unlockableContent
            self.mediaExtension = mediaExtension
            self.veracityItemId = veracityItemId
            self.veracityItemUrl = veracityItemUrl
            self.veracityItemWidth = veracityItemWidth
            self.veracityItemHeight = veracityItemHeight
        }
    }
}

extension MintTokenRequest.Attributes.Details {
    
    public struct Attributes: Encodable {
        let traitType: String
        let value: String
        
        public init(
            traitType: String,
            value: String
        ) {
            self.traitType = traitType
            self.value = value
        }
    }
}

extension MintTokenRequest {
    
    public struct Relationships: Encodable {
        let edition: EditionData?
        let draftToDelete: DraftToDeleteData
    }
}

extension MintTokenRequest.Relationships {
    
    struct EditionData: Encodable {
        let id: String
        let type: String = "create-edition"
    }
}

extension MintTokenRequest.Relationships {
    
    struct DraftToDeleteData: Encodable {
        let id: String
        let type: String = "draft-tokens"
    }
}

extension MintTokenRequest {

    struct Included: Encodable {

        let id: String
        let type: String = "create-edition"
        let attributes: Attributes
    }
}

extension MintTokenRequest.Included {
    
    struct Attributes: Encodable {
        
        let name: String
    }
}
