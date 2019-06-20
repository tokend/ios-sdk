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
    
    public func requestPolls(
        filters: PollsRequestFiltersV3,
        pagination: RequestPagination,
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
    
    public func requestPollById(
        pollId: String,
        completion: @escaping(_ result: RequestSingleResult<PollResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        let request = self.requestBuilder.buildPollByIdRequest(pollId: pollId)
        cancellable.cancelable = self.requestSingle(
            PollResource.self,
            request: request,
            completion: completion
        )
        return cancellable
    }
    
    public func requestVotes(
        pollId: String,
        pagination: RequestPagination,
        completion: @escaping(_ result: RequestCollectionResult<VoteResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        let request = self.requestBuilder.buildVotesRequest(
            pollId: pollId,
            pagination: pagination
        )
        cancellable.cancelable = self.requestCollection(
            VoteResource.self,
            request: request,
            completion: completion
        )
        return cancellable
    }
    
    public func requestVotesById(
        pollId: String,
        voterAccountId: String,
        pagination: RequestPagination,
        completion: @escaping(_ result: RequestCollectionResult<VoteResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        let request = self.requestBuilder.buildVotesByIdRequest(
            pollId: pollId,
            voterAccountId: voterAccountId,
            pagination: pagination
        )
        cancellable.cancelable = self.requestCollection(
            VoteResource.self,
            request: request,
            completion: completion
        )
        return cancellable
    }
    
    public func requestVotesById(
        voterAccountId: String,
        pagination: RequestPagination,
        completion: @escaping(_ result: RequestCollectionResult<VoteResource>) -> Void
        ) -> Cancelable {
        
        var cancellable = self.network.getEmptyCancelable()
        
        let request = self.requestBuilder.buildVotesByIdRequest(
            voterAccountId: voterAccountId,
            pagination: pagination
        )
        cancellable.cancelable = self.requestCollection(
            VoteResource.self,
            request: request,
            completion: completion
        )
        return cancellable
    }
}
