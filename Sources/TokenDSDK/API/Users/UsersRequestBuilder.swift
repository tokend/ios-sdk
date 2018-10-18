import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch user's data
public class UsersRequestBuilder {
    
    // MARK: - Public
    
    public let usersPath: String = "users"
    public let blobsPath: String = "blobs"
    
    public let apiConfiguration: ApiConfiguration
    public let requestSigner: RequestSignerProtocol
    
    // MARK: -
    
    public init(
        apiConfiguration: ApiConfiguration,
        requestSigner: RequestSignerProtocol
        ) {
        self.apiConfiguration = apiConfiguration
        self.requestSigner = requestSigner
    }
    
    // MARK: - Public
    
    /// Builds request to fetch user data from api
    /// - Parameters:
    ///   - accountId: Identifier of user's account.
    ///   - sendDate: Send time of request.
    /// - Returns: `GetUserRequest`
    public func buildGetUserRequest(accountId: String, sendDate: Date) -> GetUserRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.usersPath).addPath(accountId)
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = GetUserRequest(
            url: url,
            method: .get,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Builds request to create user
    /// - Parameters:
    ///   - accountId: Identifier of user's account.
    ///   - sendDate: Send time of request.
    /// - Returns: `CreateUserRequest`
    public func buildCreateUserRequest(accountId: String, sendDate: Date) throws -> CreateUserRequest {
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.usersPath).addPath(accountId)
        
        let model = CreateUserModel(attributes: CreateUserModel.Attributes(type: .notVerified))
        let requestData = ApiDataRequest(data: model)
        let requestDataEncoded = try requestData.encode()
        
        let requestSignModel = RequestSignParametersModel(urlString: url)
        let signedHeaders = self.requestSigner.sign(request: requestSignModel, sendDate: sendDate)
        
        let request = CreateUserRequest(
            url: url,
            method: .put,
            requestData: requestDataEncoded,
            signedHeaders: signedHeaders
        )
        
        return request
    }
    
    /// Builds request to get blob
    /// - Parameters:
    ///   - accountId: Identifier of account for which blob should be fetched.
    ///   - blobId: Identifier of blob to be fetched.
    ///   - fundId: Identifier of fund for which blob should be fetched.
    ///   - tokenCode: Base asset of fund.
    ///   - fundOwner: Name of fund owner.
    ///   - type: Blob type.
    ///   - other: Extra parameters.
    /// - Returns: `GetBlobRequest`
    public func buildGetBlobRequest(
        accountId: String,
        blobId: String,
        fundId: String?,
        tokenCode: String?,
        fundOwner: String?,
        type: Int?,
        other: RequestParameters? = nil
        ) -> GetBlobRequest {
        
        let baseUrl = self.apiConfiguration.urlString
        let url = baseUrl.addPath(self.usersPath).addPath(accountId).addPath(self.blobsPath).addPath(blobId)
        
        var parameters: RequestParameters = [:]
        
        if let fundId = fundId {
            parameters["fund_id"] = fundId
        }
        
        if let tokenCode = tokenCode {
            parameters["token_code"] = tokenCode
        }
        
        if let fundOwner = fundOwner {
            parameters["fund_owner"] = fundOwner
        }
        
        if let type = type {
            parameters["type"] = type
        }
        
        if let other = other {
            parameters.merge(other) { (value1, _) -> Any in
                return value1
            }
        }
        
        let request = GetBlobRequest(
            url: url,
            method: .get,
            parameters: parameters,
            parametersEncoding: .urlEncoding
        )
        
        return request
    }
}
