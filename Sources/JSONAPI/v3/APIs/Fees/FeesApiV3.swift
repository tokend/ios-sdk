import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch fees
public class FeesApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: FeesRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = FeesRequestBuilderV3(
            builderStack: JSONAPI.BaseApiRequestBuilderStack.fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
}

// MARK: - Public methods

public extension FeesApiV3 {
    
    /// Method sends request to get calculated fee from api.
    /// The result of request will be fetched in `completion`
    /// - Parameters:
    ///   - completion: Block that will be called when the result will be received.
    ///     - result: Member of `RequestSingleResult<Horizon.CalculatedFeeResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    func getCalculatedFees(
        for accountId: String,
        assetId: String,
        amount: Decimal,
        feeType: Int,
        subtype: Int,
        completion: @escaping (RequestSingleResult<Horizon.CalculatedFeeResource>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildCalculatedFeesRequest(
            for: accountId,
            assetId: assetId,
            amount: "\(amount)",
            feeType: "\(feeType)",
            subtype: "\(subtype)",
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    Horizon.CalculatedFeeResource.self,
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .success(let document):
                            completion(.success(document))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
}
