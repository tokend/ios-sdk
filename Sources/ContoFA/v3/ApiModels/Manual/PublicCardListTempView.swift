import Foundation

// MARK: - PublicCardListTempView

struct PublicCardListTempView: Encodable {

    let data: Data
}

extension PublicCardListTempView {

    struct Data: Encodable {

        let type: String = "public-card-list-temp-view"
        let relationships: Relationships
    }
}

extension PublicCardListTempView.Data {

    struct Relationships: Encodable {

        let owners: Owner
    }
}

extension PublicCardListTempView.Data.Relationships {

    struct Owner: Encodable {

        let data: [AccountsResource]
    }
}
