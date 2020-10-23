import Foundation

// MARK: - KYCFormResponse

public extension BlobResponse.BlobContent {

    @available(*, deprecated, message: "Use local project KYC form model")
    struct KYCFormResponse: Codable {

        public struct Documents: Codable {

            public let kycIdDocument: Attachment?
            public let kycSelfie: Attachment?

            public init(
                kycIdDocument: Attachment?,
                kycSelfie: Attachment?
                ) {

                self.kycIdDocument = kycIdDocument
                self.kycSelfie = kycSelfie
            }
        }

        public let firstName: String?
        public let lastName: String?
        public let documents: Documents?

        public init(
            firstName: String?,
            lastName: String?,
            documents: Documents?
            ) {

            self.firstName = firstName
            self.lastName = lastName
            self.documents = documents
        }
    }
}
