import Foundation
import DLJSONAPI

public final class EmptyResource: Resource {
    
    public override class var resourceType: String {
        return "_empty_res_"
    }
}

/// Model that will be fetched in completion block of request empty.
public enum RequestEmptyResult {
    
    /// Case of successful response
    case success
    
    /// Case of failed response with `Error` model
    case failure(Error)
}

/// Model that will be fetched in completion block of request single.
public enum RequestSingleResult<ResourceType: Resource> {
    
    /// Case of successful response with document which contains single `ResourceType`
    case success(Document<ResourceType>)
    
    /// Case of failed response with `ErrorObject` model
    case failure(Error)
}

/// Model that will be fetched in completion block of request collection.
public enum RequestCollectionResult<ResourceType: Resource> {
    
    /// Case of successful response with document which contains list of `ResourceType`
    case success(Document<[ResourceType]>)
    
    /// Case of failed response with `ErrorObject` model
    case failure(Error)
}
