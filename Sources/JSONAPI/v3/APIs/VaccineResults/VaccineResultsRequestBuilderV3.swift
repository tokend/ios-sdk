import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch vaccine results' data
public class VaccineResultsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties

    private var integrations: String { "integrations" }
    private var vaccineResults: String { "vaccine-results" }
    private var vaccineType: String { "vaccine-type" }

    public func buildVaccineListResults(
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
}
