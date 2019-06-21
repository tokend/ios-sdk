import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch order book data
public class PollsApiV3: JSONAPI.BaseApi {
    
    // MARK: - Public properties
    
    public let requestBuilder: PollsRequestBuilderV3
    
    // MARK: -
    
    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = PollsRequestBuilderV3(
            builderStack: .fromApiStack(apiStack)
        )
        
        super.init(apiStack: apiStack)
    }
    
    /// Returns the list of the polls according to the corresponding filter.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<PollResource>`.
    /// - Returns: `Cancelable`
    public func requestPolls(
        filters: PollsRequestFiltersV3,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping(_ result: RequestCollectionResult<PollResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        let request = self.requestBuilder.buildPollsRequest(
            filter: filters,
            pagination: pagination
        )
        cancellable.cancelable = self.requestCollection(
            PollResource.self,
            request: request,
            completion: completion
        )
        return cancellable
    }
    
    /// Returns the poll by id.
    /// - Parameters:
    ///   - pollId: Identifier of the poll.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestSingleResult<PollResource>`.
    /// - Returns: `Cancelable`
    public func requestPollById(
        pollId: String,
        completion: @escaping(_ result: RequestSingleResult<PollResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildPollByIdRequest(
            pollId: pollId,
            completion: { [weak self] (requestModel) in
                guard let request = requestModel else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                cancellable.cancelable = self?.requestSingle(
                    PollResource.self,
                    request: request,
                    completion: completion
                )
            })
        return cancellable
    }
    
    /// Returns the votes for the poll with given identifier.
    /// - Parameters:
    ///   - pollId: Identifier of the poll.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<VoteResource>`.
    /// - Returns: `Cancelable`
    public func requestVotes(
        pollId: String,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping(_ result: RequestCollectionResult<VoteResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildVotesRequest(
            pollId: pollId,
            pagination: pagination,
            completion: { [weak self] (requestModel) in
                guard let request = requestModel else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                onRequestBuilt?(request)
                cancellable.cancelable = self?.requestCollection(
                    VoteResource.self,
                    request: request,
                    completion: completion
                )
        })
        return cancellable
    }
    
    /// Returns the votes of exact voter for the poll with given identifier.
    /// - Parameters:
    ///   - pollId: Identifier of the poll.
    ///   - voterAccountId: Voter's account id.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<VoteResource>`.
    /// - Returns: `Cancelable`
    public func requestVotesById(
        pollId: String,
        voterAccountId: String,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping(_ result: RequestCollectionResult<VoteResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildVotesByIdRequest(
            pollId: pollId,
            voterAccountId: voterAccountId,
            pagination: pagination,
            completion: { [weak self] (requestModel) in
                guard let request = requestModel else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                onRequestBuilt?(request)
                cancellable.cancelable = self?.requestCollection(
                    VoteResource.self,
                    request: request,
                    completion: completion
                )
        })
        return cancellable
    }
    
    /// Returns all the votes of exact voter.
    /// - Parameters:
    ///   - voterAccountId: Voter's account id.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<VoteResource>`.
    /// - Returns: `Cancelable`
    public func requestVotesById(
        voterAccountId: String,
        pagination: RequestPagination,
        onRequestBuilt: ((_ request: JSONAPI.RequestModel) -> Void)? = nil,
        completion: @escaping(_ result: RequestCollectionResult<VoteResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        self.requestBuilder.buildVotesByIdRequest(
            voterAccountId: voterAccountId,
            pagination: pagination,
            completion: { [weak self] (requestModel) in
                guard let request = requestModel else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }
                onRequestBuilt?(request)
                cancellable.cancelable = self?.requestCollection(
                    VoteResource.self,
                    request: request,
                    completion: completion
                )
            })
        return cancellable
    }
}
