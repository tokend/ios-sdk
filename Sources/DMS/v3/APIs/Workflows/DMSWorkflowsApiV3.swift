import Foundation
import DLJSONAPI

public extension DMS {
    
    class WorkflowsApiV3: JSONAPI.BaseApi {
        
        // MARK: - Public properties
        
        public let requestBuilder: WorkflowsRequestBuilderV3
        
        // MARK: -
        
        public required init(apiStack: JSONAPI.BaseApiStack) {
            self.requestBuilder = .init(
                builderStack: .fromApiStack(apiStack)
            )
            
            super.init(apiStack: apiStack)
        }
    }
}

// MARK: - Public methods

public extension DMS.WorkflowsApiV3 {
    
    /// Returns list of supplementary files of workflow. Users, who attached them are included.
    /// - Parameters:
    ///   - workflowId: ID of workflow.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestCollectionResult<DMS.SupplementaryFilesResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    func getListOfSupplementaryFiles(
        for workflowId: String,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<DMS.SupplementaryFilesResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetListOfSupplementaryFiles(
            for: workflowId,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    DMS.SupplementaryFilesResource.self,
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
    
    /// Attaches multiple supplementary files to a workflow.
    /// This action can be performed by a reviewer on a step that is current.
    /// - Parameters:
    ///   - files: Files to attach.
    ///   - workflowId: ID of workflow.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestSingleResult<DMS.SupplementaryFilesResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    func attachMultipleSupplementaryFiles(
        _ files: [DMS.AttachSupplementaryFileResource],
        to workflowId: String,
        completion: @escaping ((_ result: RequestSingleResult<DMS.SupplementaryFilesResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let encodedRequest: [String: Any]
        do {
            encodedRequest = try files.documentDictionary()
        } catch {
            completion(.failure(error))
            return cancelable
        }
        
        self.requestBuilder.buildAttachMultipleSupplementaryFiles(
            to: workflowId,
            bodyParameters: encodedRequest,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestSingle(
                    DMS.SupplementaryFilesResource.self,
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
    
    @discardableResult
    func removeSingleSupplementaryFile(
        _ supplementaryFileId: String,
        from workflowId: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildRemoveSingleSupplementaryFile(
            supplementaryFileId,
            from: workflowId,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success:
                            completion(.success)
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    @discardableResult
    func reviewDocument(
        _ document: DMS.ReviewDocumentResource,
        on stepId: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let encodedRequest: [String: Any]
        do {
            encodedRequest = try document.documentDictionary()
        } catch {
            completion(.failure(error))
            return cancelable
        }
        
        self.requestBuilder.buildReviewDocument(
            on: stepId,
            bodyParameters: encodedRequest,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success:
                            completion(.success)
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    @discardableResult
    func saveStepChanges(
        _ changes: DMS.StepChangesResource,
        for stepId: String,
        completion: @escaping ((_ result: RequestEmptyResult) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        let encodedRequest: [String: Any]
        do {
            encodedRequest = try changes.documentDictionary()
        } catch {
            completion(.failure(error))
            return cancelable
        }
        
        self.requestBuilder.buildSaveStepChanges(
            stepId,
            bodyParameters: encodedRequest,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in
                        
                        switch result {
                        
                        case .failure(let error):
                            completion(.failure(error))
                            
                        case .success:
                            completion(.success)
                        }
                    }
                )
            }
        )
        
        return cancelable
    }
    
    /// Returns list of completed steps. Can be filtered by project and/or user.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: The block which is called when the result will be fetched
    ///   - result: The model of `RequestCollectionResult<DMS.StepsResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    func getReviewHistory(
        filters: DMS.WorkflowsRequestFiltersV3,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<DMS.StepsResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetReviewHistory(
            filters: filters,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    DMS.StepsResource.self,
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
    
    @discardableResult
    func getListOfCurrentSteps(
        filters: DMS.WorkflowsRequestFiltersV3,
        pagination: RequestPagination,
        completion: @escaping ((_ result: RequestCollectionResult<DMS.StepsResource>) -> Void)
    ) -> Cancelable {
        
        let cancelable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildGetListOfCurrentSteps(
            filters: filters,
            pagination: pagination,
            completion: { [weak self] (request) in
                
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                
                cancelable.cancelable = self?.requestCollection(
                    DMS.StepsResource.self,
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
