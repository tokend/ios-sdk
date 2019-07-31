import Foundation

/// Request build model
public struct BaseRequestBuildModelJSONAPI {
    
    // MARK: - Public properties
    
    public let path: String
    public let method: RequestMethod
    public let queryParameters: RequestQueryParameters?
    public let bodyParameters: RequestBodyParameters?
    public let headers: RequestHeaders?
    public let include: [String]?
    public let pagination: RequestPagination?
    
    // MARK: -
    
    public init(
        path: String,
        method: RequestMethod,
        queryParameters: RequestQueryParameters? = nil,
        bodyParameters: RequestBodyParameters? = nil,
        headers: RequestHeaders? = nil,
        include: [String]? = nil,
        pagination: RequestPagination? = nil
        ) {
        
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
        self.include = include
        self.pagination = pagination
    }
    
    static public func simple(
        path: String,
        method: RequestMethod
        ) -> JSONAPI.BaseRequestBuildModel {
        
        return JSONAPI.BaseRequestBuildModel(
            path: path,
            method: method
        )
    }
    
    static public func simpleQuery(
        path: String,
        method: RequestMethod,
        queryParameters: RequestQueryParameters
        ) -> JSONAPI.BaseRequestBuildModel {
        
        return JSONAPI.BaseRequestBuildModel(
            path: path,
            method: method,
            queryParameters: queryParameters
        )
    }
    
    static public func simpleBody(
        path: String,
        method: RequestMethod,
        bodyParameters: RequestBodyParameters
        ) -> JSONAPI.BaseRequestBuildModel {
        
        return JSONAPI.BaseRequestBuildModel(
            path: path,
            method: method,
            bodyParameters: bodyParameters
        )
    }
    
    static public func simplePagination(
        path: String,
        method: RequestMethod,
        pagination: RequestPagination
        ) -> JSONAPI.BaseRequestBuildModel {
        
        return JSONAPI.BaseRequestBuildModel(
            path: path,
            method: method,
            pagination: pagination
        )
    }
    
    static public func simpleQueryInclude(
        path: String,
        method: RequestMethod,
        queryParameters: RequestQueryParameters,
        include: [String]?
        ) -> JSONAPI.BaseRequestBuildModel {
        
        return JSONAPI.BaseRequestBuildModel(
            path: path,
            method: method,
            queryParameters: queryParameters,
            include: include
        )
    }
    
    static public func simpleQueryPagination(
        path: String,
        method: RequestMethod,
        queryParameters: RequestQueryParameters,
        pagination: RequestPagination
        ) -> JSONAPI.BaseRequestBuildModel {
        
        return JSONAPI.BaseRequestBuildModel(
            path: path,
            method: method,
            queryParameters: queryParameters,
            pagination: pagination
        )
    }
    
    static public func simpleQueryIncludePagination(
        path: String,
        method: RequestMethod,
        queryParameters: RequestQueryParameters,
        include: [String]?,
        pagination: RequestPagination
        ) -> JSONAPI.BaseRequestBuildModel {
        
        return JSONAPI.BaseRequestBuildModel(
            path: path,
            method: method,
            queryParameters: queryParameters,
            include: include,
            pagination: pagination
        )
    }
}

extension JSONAPI {
    
    public typealias BaseRequestBuildModel = BaseRequestBuildModelJSONAPI
}
