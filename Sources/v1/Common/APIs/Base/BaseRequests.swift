import Foundation

/// Base model for signed request.
public class RequestPlain {
    
    // MARK: - Public properties
    
    public let url: String
    public let method: RequestMethod
    
    // MARK: -
    
    public init(
        url: String,
        method: RequestMethod
        ) {
        
        self.url = url
        self.method = method
    }
}

/// Base model for signed request.
public class RequestSigned {
    
    // MARK: - Public properties
    
    public let url: String
    public let method: RequestMethod
    public let signedHeaders: RequestHeaders
    
    // MARK: -
    
    public init(
        url: String,
        method: RequestMethod,
        signedHeaders: RequestHeaders
        ) {
        
        self.url = url
        self.method = method
        self.signedHeaders = signedHeaders
    }
}

/// Base model for signed request with parameters.
public class RequestParametersSigned: RequestSigned {
    
    // MARK: - Public properties
    
    public let parameters: RequestParameters?
    public let parametersEncoding: RequestParametersEncoding
    
    // MARK: -
    
    public init(
        url: String,
        method: RequestMethod,
        parameters: RequestParameters?,
        parametersEncoding: RequestParametersEncoding,
        signedHeaders: RequestHeaders
        ) {
        
        self.parameters = parameters
        self.parametersEncoding = parametersEncoding
        
        super.init(
            url: url,
            method: method,
            signedHeaders: signedHeaders
        )
    }
}

/// Base model for signed request with raw data.
public class RequestDataSigned: RequestSigned {
    
    // MARK: - Public properties
    
    public let requestData: Data
    
    // MARK: -
    
    public init(
        url: String,
        method: RequestMethod,
        requestData: Data,
        signedHeaders: RequestHeaders
        ) {
        
        self.requestData = requestData
        
        super.init(
            url: url,
            method: method,
            signedHeaders: signedHeaders
        )
    }
}
