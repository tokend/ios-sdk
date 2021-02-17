import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch test results' data
public class VaccineResultsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties

    public let requestBuilder: VaccineResultsRequestBuilderV3

    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = VaccineResultsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public
    
    /// Method sends request to fetch vaccine results from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestCollectionResult<MunaVaccineResults.VaccineResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getVaccineListResults(
        filters: VaccineResultsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<MunaVaccineResults.VaccineResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildVaccineListResultsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    MunaVaccineResults.VaccineResource.self,
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
    
    /// Method sends request to fetch vaccine result's data from api.
    /// - Parameters:
    ///   - bookingId: Identifier of booking for which data will be fetched.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestSingleResult<MunaVaccineResults.VaccineResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getVaccineResultById(
        vaccineResultId: String,
        completion: @escaping (_ result: RequestSingleResult<MunaVaccineResults.VaccineResource>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildVaccineResultByIdRequest(
            vaccineResultId: vaccineResultId,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    MunaVaccineResults.VaccineResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                        
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    /// Method sends request to fetch vaccine types from api.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestCollectionResult<MunaVaccineResults.VaccineTypeResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getVaccineTypesList(
        filters: VaccineResultsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<MunaVaccineResults.VaccineTypeResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildVaccineTypesListRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    MunaVaccineResults.VaccineTypeResource.self,
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
    
    /// Method sends request to fetch vaccine type's data from api.
    /// - Parameters:
    ///   - bookingId: Identifier of booking for which data will be fetched.
    ///   - completion: The block which is called when the result will be fetched.
    ///   - result: The model of `RequestSingleResult<MunaVaccineResults.VaccineTypeResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func getVaccineTypeById(
        vaccineTypeId: String,
        completion: @escaping (_ result: RequestSingleResult<MunaVaccineResults.VaccineTypeResource>) -> Void
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildVaccineTypeByIdRequest(
            vaccineTypeId: vaccineTypeId,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    MunaVaccineResults.VaccineTypeResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {
                        
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success(let document):
                            completion(.success(document))
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
}
