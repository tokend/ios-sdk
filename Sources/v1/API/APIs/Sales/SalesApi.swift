import Foundation

/// Class provides functionality that allows to fetch sales' data
public class SalesApi: BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: SalesRequestBuilder
    
    // MARK: -
    
    public override init(apiStack: BaseApiStack) {
        self.requestBuilder = SalesRequestBuilder(
            builderStack: BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Model that will be fetched in completion block of `SalesApi.getSales(...)`
    public enum GetSalesResult<SaleListType: Decodable> {
        
        /// Case of failed response with `Swift.Error` model
        case failure(Swift.Error)
        
        /// Case of successful response with list of `SaleListType`
        case success([SaleListType])
    }
    
    /// Method sends request to fetch sales from api
    /// - Parameters:
    ///   - saleListType: Model type that expected to be fetched
    ///   - orderDescending: Flag that defines the order of sales
    ///   - limit: Limit of sales count
    ///   - cursor: Used to specify the start of the page (if pagination is available)
    ///   - owner: Fund owner
    ///   - name: Fund name
    ///   - baseAsset: Base asset of the fund
    ///   - openOnly: Flag which defines whether only open sales should be fetched
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `GetSalesResult<SaleListType>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getSales<SaleListType: Decodable>(
        _ saleListType: SaleListType.Type,
        orderDescending: Bool = true,
        limit: Int?,
        cursor: String?,
        page: Int?,
        owner: String?,
        name: String?,
        baseAsset: String?,
        openOnly: Bool?,
        completion: @escaping ((_ result: GetSalesResult<SaleListType>) -> Void)
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildGetSalesRequest(
            orderDescending: orderDescending,
            limit: limit,
            cursor: cursor,
            page: page,
            owner: owner,
            name: name,
            baseAsset: baseAsset,
            openOnly: openOnly
        )
        
        return self.network.responseObject(
            RequestResultPage<SalesEmbedded<SaleListType>>.self,
            url: request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.parametersEncoding,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors))
                    
                case .success(let object):
                    completion(.success(object.embedded.records))
                }
        })
    }
    
    /// Model that will be fetched in completion block of `SalesApi.GetSaleDetailsResult(...)`
    public enum GetSaleDetailsResult<SaleDetailsType: Decodable> {
        
        /// Case of failed response with `Swift.Error` model
        case failure(Swift.Error)
        
        /// Case of successful response with `SaleDetailsType` model
        case success(SaleDetailsType)
    }
    
    /// Method sends request to fetch sale details from api
    /// - Parameters:
    ///   - saleDetailsType: Model type that expected to be fetched
    ///   - saleId: Identifier of sale whose details should be fetched
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `GetSaleDetailsResult<SaleDetailsType>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getSaleDetails<SaleDetailsType: Decodable>(
        _ saleDetailsType: SaleDetailsType.Type,
        saleId: String,
        completion: @escaping ((_ result: GetSaleDetailsResult<SaleDetailsType>) -> Void)
        ) -> Cancelable {
        
        let request = self.requestBuilder.buildGetSaleDetailsRequest(saleId: saleId)
        
        return self.network.responseObject(
            saleDetailsType,
            url: request.url,
            method: request.method,
            completion: { (result) in
                switch result {
                    
                case .failure(let errors):
                    completion(.failure(errors))
                    
                case .success(let object):
                    completion(.success(object))
                }
        })
    }
}
