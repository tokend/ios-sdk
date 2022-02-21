import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch fees
public class FeesRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let accounts = "accounts"
    public let calculatedFees = "calculated_fees"
}

// MARK: - Public methods

public extension FeesRequestBuilderV3 {
    
    /// Builds request to fetch fees from api
    /// - Parameters:
    ///   - completion: Returns `RequestModelV3` or nil.
    func buildCalculatedFeesRequest(
        for accountId: String,
        assetId: String,
        amount: String,
        feeType: String,
        subtype: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.v3/self.accounts/accountId/self.calculatedFees
        
        var parameters = RequestQueryParameters()
        parameters["asset"] = assetId
        parameters["fee_type"] = feeType
        parameters["subtype"] = subtype
        parameters["amount"] = amount
        
        self.buildRequest(
            .simpleQuery(
                path: path,
                method: .get,
                queryParameters: parameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}
