import Foundation

// MARK: - CreateReactionRequest

struct CreateReactionRequest: Encodable {
    
    let titleId: String
    let reactionType: String
}
