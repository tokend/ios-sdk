import Foundation

/// Class provides functionality that allows to build order book requests
public class PollsRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    public let polls: String = "polls"
    public let relationships: String = "relationships"
    public let votes: String = "votes"
    
    // MARK: - Public
    
    // Builds the request to fetch polls.
    public func buildPollsRequest(
        filter: PollsRequestFiltersV3,
        pagination: RequestPagination
        ) -> JSONAPI.RequestModel {
        
        let path = /self.v3/self.polls
        
        let queryParameters = self.buildFilterQueryItems(filter.filterItems)
        
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryPagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                pagination: pagination
            )
        )
    }
    
    // Builds the request to fetch poll by id.
    public func buildPollByIdRequest(
        pollId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {

        let path = /self.v3/self.polls/pollId
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
    
    // Builds the request to fetch votes for poll with given id.
    public func buildVotesRequest(
        pollId: String,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.polls/pollId/self.relationships/self.votes
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
    
    // Builds the request to fetch votes for voter with given accountId, for poll with given id.
    public func buildVotesByIdRequest(
        pollId: String,
        voterAccountId: String,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.polls/pollId/self.relationships/self.votes/voterAccountId
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simplePagination(
                path: path,
                method: .get,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    // Builds the request to fetch votes for voter with given accountId.
    public func buildVotesByIdRequest(
        voterAccountId: String,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
        ) {
        
        let path = /self.v3/self.votes/voterAccountId
        return self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simplePagination(
                path: path,
                method: .get,
                pagination: pagination
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}
