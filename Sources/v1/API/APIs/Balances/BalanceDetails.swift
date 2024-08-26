import Foundation

enum BalanceDecodeHelpers {
    struct Balances: Codable {
        let included: [BalanceIncluded]

        func toBalanceDetails() -> [BalanceDetails] {
            var balanceDetails: [BalanceDetails] = []
            for include in self.included {
                if include.type == "balances-state" { 
                    guard let balance = included.first(where: {
                        $0.type == "balances" && $0.id == include.id
                    }) else { continue }

                    balanceDetails.append(
                        .init(
                            asset: balance.relationships?.asset?.data?.id ?? "",
                            balance: Decimal(string: include.attributes?.available ?? "") ?? 0,
                            locked: Decimal(string: include.attributes?.locked ?? "") ?? 0,
                            balanceId: balance.id
                        )
                    )
                }
            }
            return nil
        }
    }

    struct BalanceIncluded: Codable {
        let id: String
        let type: String
        let relationships: BalanceRelationships?
        let attributes: BalanceAttributes?
    }

    struct BalanceAttributes: Codable {
        let available: String?
        let locked: String?
    }

    struct BalanceRelationships: Codable {
        let asset: AssetData?
        let state: StateData?
    }

    struct AssetData: Codable {
        let data: Asset?
    }

    struct Asset: Codable {
        let id: String
        let type: String
    }

    struct StateData: Codable {
        let data: State?
    }

    struct State: Codable {
        let id: String
        let type: String
    }
}

public struct BalanceDetails {
    public let asset: String
    public let balance: Decimal
    public let locked: Decimal
    public let balanceId: String
}
