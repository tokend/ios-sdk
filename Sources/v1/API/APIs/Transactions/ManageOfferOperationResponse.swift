import Foundation

// MARK: - ManageOfferOperationResponse -

public final class ManageOfferOperationResponse: OperationResponseBase {
    
    public typealias Participant = CheckSaleStateOperationResponse.Participant
    
    public let participants: [Participant]
    
    // MARK: -
    
    public required init?(from unified: OperationResponseUnified) {
        self.participants = unified.participantsChecked.compactMap({ (participant) -> Participant? in
            return Participant(participant)
        })
        
        super.init(from: unified)
    }
    
    // MARK: - Public
    
    public func getSubOperations(targetAccountId: String, targetAsset: String) -> [ManageOfferSubOperation] {
        let targetParticipant = self.participants.first(where: {
            $0.accountId.caseInsensitiveCompare(targetAccountId) == .orderedSame
        })
        
        guard let targetEffect = targetParticipant?.effects.first else {
            return []
        }
        
        let baseAsset = targetEffect.baseAsset
        let quoteAsset = targetEffect.quoteAsset
        let contextAssetIsQuote = quoteAsset == targetAsset
        
        let subOperations = targetEffect.matches.map { (match) -> ManageOfferSubOperation in
            let baseAmount = match.baseAmount
            let quoteAmount = match.quoteAmount
            
            let subOperation = ManageOfferSubOperation(
                amount: contextAssetIsQuote ? quoteAmount : baseAmount,
                asset: contextAssetIsQuote ? quoteAsset : baseAsset,
                base: self,
                feeAmount: match.feePaid,
                feeAsset: quoteAsset,
                match: ManageOfferSubOperation.Match(
                    isBuy: contextAssetIsQuote != targetEffect.isBuy,
                    price: match.price,
                    quoteAmount: contextAssetIsQuote ? baseAmount : quoteAmount,
                    quoteAsset: contextAssetIsQuote ? baseAsset : quoteAsset
                ),
                parentId: self.id
            )
            
            return subOperation
        }
        
        return subOperations
    }
}

// MARK: - ManageOfferSubOperation -

public typealias ManageOfferSubOperation = CheckSaleStateSubOperation
