import Foundation

public extension DMS {
    
    class WorkflowsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
        
        // MARK: - Private properties
        
        private var integrations: String { "integrations" }
        private var dms: String { "dms" }
        private var workflows: String { "workflows" }
        private var supplementaryFiles: String { "supplementary-files" }
        private var steps: String { "steps" }
        private var draft: String { "draft" }
        private var completed: String { "completed" }
        private var current: String { "current" }
    }
}

// MARK: - Public methods

public extension DMS.WorkflowsRequestBuilderV3 {
    
    func buildGetListOfSupplementaryFiles(
        for workflowId: String,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.integrations/self.dms/self.workflows/workflowId/self.supplementaryFiles
        
        self.buildRequest(
            .simplePagination(
                path: path,
                method: .get,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    func buildAttachMultipleSupplementaryFiles(
        to workflowId: String,
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.integrations/self.dms/self.workflows/workflowId/self.supplementaryFiles
        
        self.buildRequest(
            .simpleBody(
                path: path,
                method: .post,
                bodyParameters: bodyParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    func buildRemoveSingleSupplementaryFile(
        _ supplementaryFileId: String,
        from workflowId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.integrations/self.dms/self.workflows/workflowId/self.supplementaryFiles/supplementaryFileId
        
        self.buildRequest(
            .simple(
                path: path,
                method: .delete
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    func buildReviewDocument(
        on stepId: String,
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.integrations/self.dms/self.workflows/self.steps/stepId
        
        self.buildRequest(
            .simpleBody(
                path: path,
                method: .patch,
                bodyParameters: bodyParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    func buildSaveStepChanges(
        _ stepId: String,
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.integrations/self.dms/self.workflows/self.steps/stepId/self.draft
        
        self.buildRequest(
            .simpleBody(
                path: path,
                method: .patch,
                bodyParameters: bodyParameters
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    func buildGetReviewHistory(
        filters: DMS.WorkflowsRequestFiltersV3,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.integrations/self.dms/self.workflows/self.steps/self.completed
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQueryPagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    func buildGetListOfCurrentSteps(
        filters: DMS.WorkflowsRequestFiltersV3,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.integrations/self.dms/self.workflows/self.steps/self.current
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            .simpleQueryPagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}
