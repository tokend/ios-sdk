import Foundation
import Alamofire

/// Class implements sending requests to api and getting responses
public class Network {
    
    public let userAgent: String
    
    public init(userAgent: String) {
        self.userAgent = userAgent
    }
    
    // MARK: - Public
    
    // MARK: - Single Object Response
    
    /// Model that will be fetched in `completion` block
    /// of `Network.responseObject(...)`
    public enum ResponseObjectResult<T: Decodable> {
        
        /// Case of successful response with `T` model
        case success(object: T)
        
        /// Case of failed response with `ApiErrors` model
        case failure(errors: ApiErrors)
    }
    
    /// Method sends request to api and expects to fetch the model of `T` type
    /// - Parameters:
    ///     - type: Type of the model that expected to be fetched
    ///     - url: URL of request
    ///     - method: Method of request
    ///     - parameters: Parameters of request
    ///     - encoding: Encoding which is used to encode request parameters
    ///     - headers: Headers of request
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `ResponseObjectResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func responseObject<T: Decodable> (
        _ type: T.Type,
        url: String,
        method: RequestMethod,
        parameters: RequestParameters? = nil,
        encoding: RequestParametersEncoding = .urlEncoding,
        headers: RequestHeaders? = nil,
        completion: @escaping (_ result: ResponseObjectResult<T>) -> Void
        ) -> CancellableToken {
        
        let request = Alamofire
            .request(
                url,
                method: method.method,
                parameters: parameters,
                encoding: encoding.encoding,
                headers: headers
            )
            .validate()
            .responseObject(type.self) { response in
                switch response.result {
                    
                case .success(let object):
                    completion(.success(object: object))
                    
                case .failure(let error):
                    let errors = self.errorsFromResponseData(response.data, defaultError: error)
                    completion(.failure(errors: errors))
                }
        }
        
        return CancellableToken(request: request)
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
    
    /// Method sends request to api and expects to fetch the response in json format
    /// - Parameters:
    ///     - url: URL of request
    ///     - method: Method of request
    ///     - parameters: Parameters of request
    ///     - encoding: Encoding which is used to encode request parameters
    ///     - headers: Headers of request
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `ResponseJSONResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func responseJSON(
        url: String,
        method: RequestMethod,
        parameters: RequestParameters? = nil,
        encoding: RequestParametersEncoding = .urlEncoding,
        headers: RequestHeaders? = nil,
        completion: @escaping (_ result: ResponseJSONResult) -> Void
        ) -> CancellableToken {
        
        let request = Alamofire
            .request(
                url,
                method: method.method,
                parameters: parameters,
                encoding: encoding.encoding,
                headers: headers
            )
            .validate()
            .responseJSON { (response) in
                switch response.result {
                    
                case .success(let json):
                    completion(.success(json: json))
                    
                case .failure(let error):
                    let errors = self.errorsFromResponseData(response.data, defaultError: error)
                    completion(.failure(errors: errors))
                }
        }
        
        return CancellableToken(request: request)
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
    
    /// Method sends request to api. The response is not expected to be received
    /// - Parameters:
    ///     - url: URL of request
    ///     - method: Method of request
    ///     - bodyData: Body of request
    ///     - headers: Headers of request
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `ResponseDataEmptyResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func responseDataEmpty(
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseDataEmptyResult) -> Void
        ) -> CancellableToken {
        
        return self.responseData(
            .empty,
            responseType: Empty.self,
            url: url,
            method: method,
            headers: headers,
            bodyData: bodyData,
            completion: { (result) in
                
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors: errors))
                    
                case .success:
                    completion(.success)
                }
        })
    }
    
    /// Model that will be fetched in `completion` block
    /// of `Network.responseRawData(...)`
    public enum ResponseRawDataResult {
        
        /// Case of successful response with `Data` model
        case success(Data)
        
        /// Case of failed response with `ApiErrors` model
        case failure(errors: ApiErrors)
    }
    
    /// Method sends request to api and expects to fetch the model of `Data` type
    /// - Parameters:
    ///     - url: URL of request
    ///     - method: Method of request
    ///     - headers: Headers of request
    ///     - bodyData: Body of request
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `ResponseRawDataResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func responseRawData(
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseRawDataResult) -> Void
        ) -> CancellableToken {
        
        return self.responseData(
            .rawData,
            responseType: Data.self,
            url: url,
            method: method,
            headers: headers,
            bodyData: bodyData,
            completion: { (result) in
                
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors: errors))
                    
                case .success(let result):
                    switch result {
                        
                    case .data(let data):
                        completion(.success(data))
                        
                    case .empty,
                         .object:
                        fatalError("Result must be data")
                    }
                }
        })
    }
    
    /// Model that will be fetched in `completion` block
    /// of `Network.responseDataObject(...)`
    public enum ResponseDataObjectResult<T: Decodable> {
        
        /// Case of successful response with `T` model
        case success(T)
        
        /// Case of failed response with `ApiErrors` model
        case failure(errors: ApiErrors)
    }
    
    /// Method sends request to api and expects to fetch the model of `T` type
    /// - Parameters:
    ///     - type: Type of the model that expected to be fetched
    ///     - url: URL of request
    ///     - method: Method of request
    ///     - headers: Headers of request
    ///     - bodyData: Body of request
    ///     - completion: The block which is called when the result of request is fetched
    ///     - result: The member of `ResponseDataObjectResult`
    /// - Returns: `CancellableToken`
    @discardableResult
    public func responseDataObject<T: Decodable>(
        _ type: T.Type,
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseDataObjectResult<T>) -> Void
        ) -> CancellableToken {
        
        return self.responseData(
            .object,
            responseType: type,
            url: url,
            method: method,
            headers: headers,
            bodyData: bodyData,
            completion: { (result) in
                
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors: errors))
                    
                case .success(let result):
                    
                    switch result {
                        
                    case .object(let object):
                        completion(.success(object))
                        
                    case .empty,
                         .data:
                        fatalError("Result must be object")
                    }
                }
        })
    }
    
    // MARK: - Private
    
    private typealias ResponseDataType = Decodable
    private enum ResponseDataResult<T: ResponseDataType> {
        enum SuccessResult {
            case empty
            case object(T)
            case data(Data)
        }
        
        case success(SuccessResult)
        case failure(errors: ApiErrors)
    }
    private enum ResponseDataResultType {
        case empty
        case object
        case rawData
    }
    @discardableResult
    private func responseData<T: ResponseDataType>(
        _ type: ResponseDataResultType,
        responseType: T.Type,
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseDataResult<T>) -> Void
        ) -> CancellableToken {
        
        guard var urlRequest = try? URLRequest(url: url, method: method.method, headers: headers) else {
            completion(.failure(errors: ApiErrors(
                errors: [
                    // TODO: Provide error details
                    ApiError(
                        status: ApiError.Status.urlEncodeFailed,
                        code: nil,
                        title: ApiError.Title.urlEncodeFailed,
                        detail: nil,
                        meta: nil,
                        horizonError: nil
                    )
                ]))
            )
            return CancellableToken(request: nil)
        }
        urlRequest.httpBody = bodyData
        
        let request = Alamofire
            .request(urlRequest)
            .validate()
        
        switch type {
            
        case .empty:
            request.responseData { (response) in
                switch response.result {
                    
                case .success:
                    completion(.success(.empty))
                    
                case .failure(let error):
                    let errors = self.errorsFromResponseData(response.data, defaultError: error)
                    completion(.failure(errors: errors))
                }
            }
            
        case .object:
            request.responseObject(responseType) { response in
                switch response.result {
                    
                case .success(let object):
                    completion(.success(.object(object)))
                    
                case .failure(let error):
                    let errors = self.errorsFromResponseData(response.data, defaultError: error)
                    completion(.failure(errors: errors))
                }
            }
            
        case .rawData:
            request.responseData { (response) in
                switch response.result {
                    
                case .success(let result):
                    completion(.success(.data(result)))
                    
                case .failure(let error):
                    let errors = self.errorsFromResponseData(response.data, defaultError: error)
                    completion(.failure(errors: errors))
                }
            }
        }
        
        return CancellableToken(request: request)
    }
    
    private func prepareHeaders(headers: RequestHeaders?) -> RequestHeaders {
        var preparedHeaders = headers ?? RequestHeaders()
        
        preparedHeaders["User-Agent"] = self.userAgent
        
        return preparedHeaders
    }
    
    private func addContentTypeHeader(headers: RequestHeaders?) -> RequestHeaders {
        var existingHeaders = headers ?? RequestHeaders()
        
        existingHeaders["Content-Type"] = "application/vnd.api+json"
        existingHeaders["Accept"] = "application/vnd.api+json"
        
        return existingHeaders
    }
    
    private func errorsFromResponseData(
        _ responseData: Data?,
        defaultError: Swift.Error
        ) -> ApiErrors {
        
        let nsError = defaultError as NSError
        let defaultApiError = ApiError(
            status: "\(nsError.code)",
            code: nil,
            title: nil,
            detail: nsError.localizedDescription
        )
        let defaultApiErrors = ApiErrors(errors: [defaultApiError])
        
        guard let data = responseData else {
            return defaultApiErrors
        }
        
        if let updatedHorrizonError = try? HorizonErrorsV2.decode(from: data) {
            var errors: [ApiError] = []
            
            for error in updatedHorrizonError.errors {
                errors.append(
                    ApiError(
                        status: "\(error.status)",
                        code: error.code,
                        title: error.title,
                        detail: error.detail,
                        meta: nil,
                        horizonErrorV2: error
                    )
                )
            }
            return ApiErrors(errors: errors)
        } else if let errors = try? ApiErrors.decode(from: data) {
            return errors
        } else if let horizonError = try? HorizonError.decode(from: data) {
            return ApiErrors(
                errors: [
                    ApiError(
                        status: "\(horizonError.status)",
                        code: horizonError.type,
                        title: horizonError.title,
                        detail: horizonError.detail,
                        meta: nil,
                        horizonError: horizonError
                    )
                ]
            )
        }
        
        return defaultApiErrors
    }
}
