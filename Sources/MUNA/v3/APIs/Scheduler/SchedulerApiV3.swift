import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch test results' data
public class SchedulerApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties

    public let requestBuilder: SchedulerRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = SchedulerRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    // MARK: - Public

    @discardableResult
    public func getFreeBusy(
        calendarId: String,
        startTime: Int,
        endTime: Int,
        payload: String,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<MunaScheduler.FreeBusyResource>) -> Void)
        ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildFreeBusyRequest(
            calendarId: calendarId,
            startTime: startTime,
            endTime: endTime,
            payload: payload,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    MunaScheduler.FreeBusyResource.self,
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
