import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch vaccine results' data
public class VaccineResultsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties

    private var integrations: String { "integrations" }
    private var vaccineResults: String { "vaccine-results" }
    private var vaccineType: String { "vaccine-type" }

    /// Builds request to get vaccine results list
    public func buildVaccineListResultsRequest(
        filters: VaccineResultsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = /self.integrations/self.vaccineResults
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to get vaccine result
    /// - Parameters:
    ///   - vaccineResultId: The vaccine result id.
    public func buildVaccineResultByIdRequest(
        vaccineResultId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.vaccineResults/vaccineResultId
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to get vaccine types list
    public func buildVaccineTypesListRequest(
        filters: VaccineResultsRequestFiltersV3,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.vaccineResults/self.vaccineType
        
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQueryIncludePagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                include: include,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    /// Builds request to get vaccine result
    /// - Parameters:
    ///   - vaccineTypeId: The vaccine result id.
    public func buildVaccineTypeByIdRequest(
        vaccineTypeId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.integrations/self.vaccineResults/self.vaccineType/vaccineTypeId
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}
