import Foundation
import Alamofire

/// Class implements sending requests to api and getting responses
public class AlamofireNetwork {
    
    // MARK: - Public properties
    
    public let userAgent: String?
    public let onUnathorizedRequest: (_ error: ApiErrors) -> Void
    
    /// Log detail level for NetworkActivityLogger.
    /// Default is `debug`.
    public var loggerLevel: NetworkActivityLoggerLevel {
        get { return NetworkActivityLogger.shared.level }
        set { NetworkActivityLogger.shared.level = newValue }
    }
    
    // MARK: -
    
    public init(
        userAgent: String? = nil,
        onUnathorizedRequest: @escaping (_ error: ApiErrors) -> Void
        ) {
        
        self.userAgent = userAgent
        self.onUnathorizedRequest = onUnathorizedRequest
        self.loggerLevel = .debug
    }
    
    // MARK: - Public
    
    public func startLogger() {
        NetworkActivityLogger.shared.startLogging()
    }
    
    public func stopLogger() {
        NetworkActivityLogger.shared.stopLogging()
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
        ) -> Cancelable {
        
        guard var urlRequest = try? URLRequest(url: url, method: method.method, headers: headers) else {
            completion(.failure(errors: ApiErrors(
                errors: [
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
            return self.getEmptyCancelable()
        }
        urlRequest.httpBody = bodyData
        
        let request = AF
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
        
        return self.getEmptyCancelable()
    }
    
    private func prepareHeaders(headers: RequestHeaders?) -> RequestHeaders {
        var preparedHeaders = headers ?? RequestHeaders()
        
        if let userAgent = self.userAgent {
            preparedHeaders["User-Agent"] = userAgent
        }
        
        return preparedHeaders
    }
    
    private func errorsFromResponseData(
        _ responseData: Data?,
        defaultError: Swift.Error
        ) -> ApiErrors {
        
        let errors = self.parseErrorsFromResponseData(
            responseData,
            defaultError: defaultError
        )
        
        if errors.contains(status: ApiError.Status.unauthorized) {
            self.onUnathorizedRequest(errors)
        }
        
        return errors
    }
    
    private func parseErrorsFromResponseData(
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
        
        // HorizonErrorsV2 is not fully supported/implemented
//        if let updatedHorrizonError = try? HorizonErrorsV2.decode(from: data) {
//            var errors: [ApiError] = []
//
//            for error in updatedHorrizonError.errors {
//                errors.append(
//                    ApiError(
//                        status: "\(error.status)",
//                        code: error.code,
//                        title: error.title,
//                        detail: error.detail,
//                        meta: nil,
//                        horizonErrorV2: error
//                    )
//                )
//            }
//            return ApiErrors(errors: errors)
//        } else
        if let errors = try? ApiErrors.decode(from: data) {
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

extension AlamofireNetwork: NetworkProtocol {
    
    public func getEmptyCancelable() -> Cancelable {
        return AlamofireCancelable(request: nil)
    }
    
    @discardableResult
    public func responseObject<T: Decodable> (
        _ type: T.Type,
        url: String,
        method: RequestMethod,
        parameters: RequestParameters? = nil,
        encoding: RequestParametersEncoding = .url,
        headers: RequestHeaders? = nil,
        completion: @escaping (_ result: ResponseObjectResult<T>) -> Void
        ) -> Cancelable {
        
        let request = AF
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
        
        return AlamofireCancelable(request: request)
    }
    
    @discardableResult
    public func responseJSON(
        url: String,
        method: RequestMethod,
        parameters: RequestParameters? = nil,
        encoding: RequestParametersEncoding = .url,
        headers: RequestHeaders? = nil,
        completion: @escaping (_ result: ResponseJSONResult) -> Void
        ) -> Cancelable {
        
        let request = AF
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
        
        return AlamofireCancelable(request: request)
    }
    
    @discardableResult
    public func responseDataEmpty(
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseDataEmptyResult) -> Void
        ) -> Cancelable {
        
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
    
    @discardableResult
    public func responseRawData(
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseRawDataResult) -> Void
        ) -> Cancelable {
        
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
    
    @discardableResult
    public func responseDataObject<T: Decodable>(
        _ type: T.Type,
        url: String,
        method: RequestMethod,
        headers: RequestHeaders? = nil,
        bodyData: Data? = nil,
        completion: @escaping (_ result: ResponseDataObjectResult<T>) -> Void
        ) -> Cancelable {
        
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
    
    public func uploadMultiPartFormData(
        url: String,
        formData: JSON,
        uploadOption: DocumentUploadOption,
        completion: @escaping (ResponseMultiPartFormDataResult) -> Void
        ) -> Cancelable {
        
        let cancelable = AlamofireCancelable(request: nil)
        
        AF.upload(
            multipartFormData: { (multipartFormData) in
                formData.forEach({ (key, value) in
                    guard let valueData = "\(value)".data(using: .utf8) else {
                        return
                    }
                    
                    multipartFormData.append(valueData, withName: key)
                })
                
                switch uploadOption {
                    
                case .data(let data, let meta):
                    multipartFormData.append(
                        data,
                        withName: "file",
                        fileName: meta.fileName,
                        mimeType: meta.mimeType
                    )
                    
                case .stream(let stream, let length, let meta):
                    multipartFormData.append(
                        stream,
                        withLength: length,
                        name: "file",
                        fileName: meta.fileName,
                        mimeType: meta.mimeType
                    )
                }
            },
            to: url
        )
        .validate()
        .responseData { (response) in

            switch response.result {

            case .failure(let error):
                completion(.failure(error: error))

            case .success:
                completion(.success)
            }
        }
        
        return cancelable
    }
}
