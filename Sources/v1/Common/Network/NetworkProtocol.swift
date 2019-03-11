import Foundation

// MARK: - Single Object Response

/// Model that will be fetched in `completion` block
/// of `Network.responseObject(...)`
public enum ResponseObjectResult<T: Decodable> {
    
    /// Case of successful response with `T` model
    case success(object: T)
    
    /// Case of failed response with `ApiErrors` model
    case failure(errors: ApiErrors)
}

// MARK: - Plain JSON Response

/// Model that will be fetched in `completion` block
/// of `Network.responseJSON(...)`
public enum ResponseJSONResult {
    
    /// Case of failed response with `Any` model
    case success(json: Any)
    
    /// Case of failed response with `ApiErrors` model
    case failure(errors: ApiErrors)
}

// MARK: - Data Response

/// Model that will be fetched in `completion` block
/// of `Network.responseDataEmpty(...)`
public enum ResponseDataEmptyResult {
    
    /// Case of successful response
    case success
    
    /// Case of failed response with `ApiErrors` model
    case failure(errors: ApiErrors)
}

/// Model that will be fetched in `completion` block
/// of `Network.responseRawData(...)`
public enum ResponseRawDataResult {
    
    /// Case of successful response with `Data` model
    case success(Data)
    
    /// Case of failed response with `ApiErrors` model
    case failure(errors: ApiErrors)
}

/// Model that will be fetched in `completion` block
/// of `Network.responseDataObject(...)`
public enum ResponseDataObjectResult<T: Decodable> {
    
    /// Case of successful response with `T` model
    case success(T)
    
    /// Case of failed response with `ApiErrors` model
    case failure(errors: ApiErrors)
}

/// Network access protocol
public protocol NetworkProtocol {
    
    /// Method returns empty cancelable placeholder that can be used later.
    /// - Returns: `Cancelable`
    func getEmptyCancelable() -> Cancelable
    
    /// Method sends request to api and expects to fetch the model of `T` type
    /// - Parameters:
    ///   - type: Type of the model that expected to be fetched
    ///   - url: URL of request
    ///   - method: Method of request
    ///   - parameters: Parameters of request
    ///   - encoding: Encoding which is used to encode request parameters
    ///   - headers: Headers of request
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `ResponseObjectResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func responseObject<T: Decodable> (
        _ type: T.Type,
        url: String,
        method: RequestMethod,
        parameters: RequestParameters?,
        encoding: RequestParametersEncoding,
        headers: RequestHeaders?,
        completion: @escaping (_ result: ResponseObjectResult<T>) -> Void
        ) -> Cancelable
    
    /// Method sends request to api and expects to fetch the response in json format
    /// - Parameters:
    ///   - url: URL of request
    ///   - method: Method of request
    ///   - parameters: Parameters of request
    ///   - encoding: Encoding which is used to encode request parameters
    ///   - headers: Headers of request
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `ResponseJSONResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func responseJSON(
        url: String,
        method: RequestMethod,
        parameters: RequestParameters?,
        encoding: RequestParametersEncoding,
        headers: RequestHeaders?,
        completion: @escaping (_ result: ResponseJSONResult) -> Void
        ) -> Cancelable
    
    /// Method sends request to api. The response is not expected to be received
    /// - Parameters:
    ///   - url: URL of request
    ///   - method: Method of request
    ///   - bodyData: Body of request
    ///   - headers: Headers of request
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `ResponseDataEmptyResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func responseDataEmpty(
        url: String,
        method: RequestMethod,
        headers: RequestHeaders?,
        bodyData: Data?,
        completion: @escaping (_ result: ResponseDataEmptyResult) -> Void
        ) -> Cancelable
    
    /// Method sends request to api and expects to fetch the model of `Data` type
    /// - Parameters:
    ///   - url: URL of request
    ///   - method: Method of request
    ///   - headers: Headers of request
    ///   - bodyData: Body of request
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `ResponseRawDataResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func responseRawData(
        url: String,
        method: RequestMethod,
        headers: RequestHeaders?,
        bodyData: Data?,
        completion: @escaping (_ result: ResponseRawDataResult) -> Void
        ) -> Cancelable
    
    /// Method sends request to api and expects to fetch the model of `T` type
    /// - Parameters:
    ///   - type: Type of the model that expected to be fetched
    ///   - url: URL of request
    ///   - method: Method of request
    ///   - headers: Headers of request
    ///   - bodyData: Body of request
    ///   - completion: The block which is called when the result of request is fetched
    ///   - result: The member of `ResponseDataObjectResult`
    /// - Returns: `Cancelable`
    @discardableResult
    func responseDataObject<T: Decodable>(
        _ type: T.Type,
        url: String,
        method: RequestMethod,
        headers: RequestHeaders?,
        bodyData: Data?,
        completion: @escaping (_ result: ResponseDataObjectResult<T>) -> Void
        ) -> Cancelable
}
