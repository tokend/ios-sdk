import Foundation

public extension DMS {
    
    class UsersRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
        
        // MARK: - Private properties
        
        private var users: String { "users" }
    }
}

// MARK: - Public methods

public extension DMS.UsersRequestBuilderV3 {
    
    func buildGetUser(
        for accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        
        let path = self.users/accountId
        
        self.buildRequest(
            .simple(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}
