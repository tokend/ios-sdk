import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch sales' data
public class SalesRequestBuilder: BaseApiRequestBuilder {
    
    public let salesPath: String = "sales"
    
    // MARK: - Public
    
    /// Builds request to fetch sales.
    /// - Parameters:
    ///   - orderDescending: flag that defines the order of sales
    ///   - cursor: Used to specify the start of the page
    ///   - owner: The owner of the fund
    ///   - name: The name of the fund
    ///   - baseAsset: The base asset for investing
    ///   - openOnly: The flag that filters closed sales
    ///   - other: Extra request parameters
    /// - Returns: `GetSalesRequest`
    public func buildGetSalesRequest(
        orderDescending: Bool = true,
        limit: Int?,
        cursor: String?,
        page: Int?,
        owner: String?,
        name: String?,
        baseAsset: String?,
        openOnly: Bool?,
        other: RequestParameters? = nil
        ) -> GetSalesRequest {
        
        let url = self.apiConfiguration.urlString.addPath(self.salesPath)
        
        var parameters: RequestParameters = [:]
        
        if orderDescending {
            parameters["order"] = "desc"
        } else {
            parameters["order"] = "asc"
        }
        
        if let limit = limit {
            parameters["limit"] = limit
        }
        
        if let cursor = cursor {
            parameters["cursor"] = cursor
        }
        
        if let page = page {
            parameters["page"] = page
        }
        
        if let owner = owner {
            parameters["owner"] = owner
        }
        
        if let name = name {
            parameters["name"] = name
        }
        
        if let baseAsset = baseAsset {
            parameters["base_asset"] = baseAsset
        }
        
        if let openOnly = openOnly {
            switch openOnly {
            case true:
                parameters["open_only"] = "true"
            case false:
                parameters["open_only"] = "false"
            }
        }
        
        if let other = other {
            parameters.merge(other) { (value1, _) -> Any in
                return value1
            }
        }
        
        let request = GetSalesRequest(
            url: url,
            method: .get,
            parameters: parameters.isEmpty ? nil : parameters,
            parametersEncoding: .url
        )
        
        return request
    }
    
    /// Builds request to fetch sale with exact id.
    /// - Parameters:
    ///   - id: The id of the sale
    /// - Returns: `GetSaleDetailsRequest`
    public func buildGetSaleDetailsRequest(
        saleId: String
        ) -> GetSaleDetailsRequest {
        
        let url = self.apiConfiguration.urlString.addPath(self.salesPath).addPath(saleId)
        
        let request = GetSaleDetailsRequest(
            url: url,
            method: .get
        )
        
        return request
    }
}
