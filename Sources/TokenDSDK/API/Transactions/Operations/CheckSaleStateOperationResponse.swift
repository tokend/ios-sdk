import Foundation

// MARK: - CheckSaleStateOperationResponse -

public final class CheckSaleStateOperationResponse: OperationResponseBase {
    
    public let participants: [Participant]
    
    // MARK: -
    
    public required init?(from unified: OperationResponseUnified) {
        self.participants = unified.participantsChecked.compactMap({ (participant) -> Participant? in
            return Participant(participant)
        })
        
        super.init(from: unified)
    }
    
    // MARK: - Public
    
    public func getSubOperations(targetAccountId: String, targetAsset: String) -> [CheckSaleStateSubOperation] {
        let targetParticipants = self.participants.filter {
            $0.accountId.caseInsensitiveCompare(targetAccountId) == .orderedSame
        }
        
        let contextAssetIsBase: Bool = targetParticipants.first(where: { participant -> Bool in
            return participant.effects.first(where: {
                $0.baseAsset == targetAsset
            }) != nil
        }) != nil
        
        // If we have investments in some token and we are looking
        // for transactions for this token, we would like to get all investments.
        // Otherwise we would like to get only investment made with this token.
        
        let targetParticipantFind: Participant?
        if contextAssetIsBase {
            targetParticipantFind = targetParticipants.max(by: {
                $0.effects.count < $1.effects.count
            })
        } else {
            targetParticipantFind = targetParticipants.first(where: {
                ($0.effects.count == 1) && ($0.effects.first(where: {
                    $0.quoteAsset == targetAsset
                }) != nil)
            })
        }
        
        guard let targetParticipant = targetParticipantFind else {
            return []
        }
        
        let subOperations = targetParticipant.effects.map { (effect) -> CheckSaleStateSubOperation in
            let baseAsset: String = effect.baseAsset
            let quoteAsset: String = effect.quoteAsset
            
            let quoteAmount: Decimal
            let baseAmount: Decimal
            let feeAmount: Decimal
            let price: Decimal
            
            if let match = effect.matches.first {
                quoteAmount = match.quoteAmount
                baseAmount = match.baseAmount
                feeAmount = match.feePaid
                price = match.price
            } else {
                quoteAmount = 0
                baseAmount = 0
                feeAmount = 0
                price = 0
            }
            
            let subOperation = CheckSaleStateSubOperation(
                amount: contextAssetIsBase ? baseAmount : quoteAmount,
                asset: contextAssetIsBase ? baseAsset : quoteAsset,
                base: self,
                feeAmount: feeAmount,
                feeAsset: quoteAsset,
                match: CheckSaleStateSubOperation.Match(
                    isBuy: contextAssetIsBase && effect.isBuy,
                    price: price,
                    quoteAmount: contextAssetIsBase ? quoteAmount : baseAmount,
                    quoteAsset: contextAssetIsBase ? quoteAsset : baseAsset
                ),
                parentId: self.id
            )
            
            return subOperation
        }
        
        return subOperations
    }
}

// MARK: - Participant

extension CheckSaleStateOperationResponse {
    
    public struct Participant {
        
        public let accountId: String
        public let balanceId: String
        public let effects: [Effect]
        
        public init?(_ unified: OperationResponseUnified.Participant) {
            guard
                let accountId = unified.accountId,
                let balanceId = unified.balanceId
                else {
                    return nil
            }
            
            self.accountId = accountId
            self.balanceId = balanceId
            self.effects = unified.effectsChecked.compactMap({ (effect) -> Effect? in
                return Effect(effect)
            })
        }
    }
}

// MARK: - Effect

extension CheckSaleStateOperationResponse.Participant {
    
    public struct Effect {
        
        public let baseAsset: String
        public let isBuy: Bool
        public let matches: [Match]
        public let quoteAsset: String
        
        public init?(_ unified: OperationResponseUnified.Participant.Effect) {
            guard
                let baseAsset = unified.baseAsset,
                let quoteAsset = unified.quoteAsset
                else {
                    return nil
            }
            
            self.baseAsset = baseAsset
            self.isBuy = unified.isBuy
            self.matches = unified.matchesChecked.compactMap({ (match) -> Match? in
                return Match(match)
            })
            self.quoteAsset = quoteAsset
        }
    }
}

// MARK: - Match

extension CheckSaleStateOperationResponse.Participant.Effect {
    
    public struct Match {
        
        public let baseAmount: Decimal
        public let feePaid: Decimal
        public let price: Decimal
        public let quoteAmount: Decimal
        
        public init?(_ unified: OperationResponseUnified.Participant.Effect.Match) {
            self.baseAmount = unified.baseAmount
            self.feePaid = unified.feePaid
            self.price = unified.price
            self.quoteAmount = unified.quoteAmount
        }
    }
}

// MARK: - CheckSaleStateSubOperation -

public class CheckSaleStateSubOperation {
    
    public let amount: Decimal
    public let asset: String
    public let base: OperationResponseBase
    public let feeAsset: String
    public let feeAmount: Decimal
    public let match: Match
    public let parentId: UInt64
    
    // MARK: -
    
    public init(
        amount: Decimal,
        asset: String,
        base: OperationResponseBase,
        feeAmount: Decimal,
        feeAsset: String,
        match: Match,
        parentId: UInt64
        ) {
        
        self.amount = amount
        self.asset = asset
        self.base = base
        self.feeAmount = feeAmount
        self.feeAsset = feeAsset
        self.match = match
        self.parentId = parentId
    }
}

// MARK: - Match

extension CheckSaleStateSubOperation {
    
    public struct Match {
        
        public let isBuy: Bool
        public let price: Decimal
        public let quoteAmount: Decimal
        public let quoteAsset: String
        
        // MARK: -
        
        public init(
            isBuy: Bool,
            price: Decimal,
            quoteAmount: Decimal,
            quoteAsset: String
            ) {
            
            self.isBuy = isBuy
            self.price = price
            self.quoteAmount = quoteAmount
            self.quoteAsset = quoteAsset
        }
    }
}
