import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch scheduler data
public class SchedulerRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties

    private var integrations: String { "integrations" }
    private var scheduler: String { "scheduler" }
    private var calendars: String { "calendars" }
    private var freebusy: String { "freebusy" }
    
    public func buildFreeBusyRequest(
        calendarId: String,
        startTime: Int,
        endTime: Int,
        payload: String,
        include: [String]?,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = self.integrations/self.scheduler/self.calendars/calendarId/self.freebusy
        
        let queryParameters: RequestQueryParameters = [
            "start-time": "\(startTime)",
            "end-time": "\(endTime)",
            "payload": payload
        ]
        
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
