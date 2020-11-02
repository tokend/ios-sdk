import Foundation

/// Namespace for upload policy possible values.
public enum UploadPolicy {}

extension UploadPolicy {
    
    public enum PolicyType {
        
        /// asset_logo. Public.
        public static let assetLogo: String = "asset_logo"
        /// fund_logo. Public.
        public static let fundLogo: String = "fund_logo"
        /// fund_document. Public.
        public static let fundDocument: String = "fund_document"
        /// nav_report. Public.
        public static let navReport: String = "nav_report"
        /// alpha. Public.
        public static let alpha: String = "alpha"
        /// bravo. Public.
        public static let bravo: String = "bravo"
        /// charlie. Public.
        public static let charlie: String = "charlie"
        /// delta. Public.
        public static let delta: String = "delta"
        /// token_terms. Public.
        public static let tokenTerms: String = "token_terms"
        /// token_metrics. Public.
        public static let tokenMetrics: String = "token_metrics"
        /// general_public. Public.
        public static let generalPublic: String = "general_public"
        /// asset_photo. Public.
        public static let assetPhoto: String = "asset_photo"
        /// kyc_id_document. Private.
        public static let kycIdDocument: String = "kyc_id_document"
        /// kyc_poa. Private.
        public static let kycPoa: String = "kyc_poa"
        /// kyc_selfie. Private.
        public static let kycAvatar: String = "kyc_avatar"
        /// general_private. Private.
        public static let generalPrivate: String = "general_private"
    }
    
    public enum ContentType {
        
        public static let applicationPdf: String = "application/pdf"
        public static let imageGif: String = "image/gif"
        public static let imageJpeg: String = "image/jpeg"
        public static let imagePng: String = "image/png"
        public static let imageTiff: String = "image/tiff"
    }
}
