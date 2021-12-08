import Foundation

public extension Contoparty {
    
    class MintTokenRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
        
        // MARK: - Private properties
        
        private var tokens: String { "tokens" }
        private var v2: String { "v2" }
        private var mint: String { "mint" }
    }
}

// MARK: - Public methods

public extension Contoparty.MintTokenRequestBuilderV3 {
    
    func buildMintTokenRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = /self.tokens/self.v2/self.mint
        
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
}
