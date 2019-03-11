import Foundation

public enum BlobType {
    
    /// `asset_description`. Public. Filter mask: 1.
    public static let assetDescription: String = "asset_description"
    
    /// `fund_overview`. Public. Filter mask: 2.
    public static let fundOverview: String = "fund_overview"
    
    /// `fund_update`. Public. Filter mask: 4.
    public static let fundUpdate: String = "fund_update"
    
    /// `nav_update`. Public. Filter mask: 8.
    public static let navUpdate: String = "nav_update"
    
    /// `fund_document`. Public. Filter mask: 16.
    public static let fundDocument: String = "fund_document"
    
    /// `alpha`. Public. Filter mask: 32.
    public static let alpha: String = "alpha"
    
    /// `bravo`. Public. Filter mask: 64.
    public static let bravo: String = "bravo"
    
    /// `charlie`. Public. Filter mask: 128.
    public static let charlie: String = "charlie"
    
    /// `delta`. Public. Filter mask: 256.
    public static let delta: String = "delta"
    
    /// `token_terms`. Public. Filter mask: 512.
    public static let tokenTerms: String = "token_terms"
    
    /// `token_metrics`. Public. Filter mask: 1024.
    public static let tokenMetrics: String = "token_metrics"
    
    /// `kyc_form`. Private. Filter mask: 2048.
    public static let kycForm: String = "kyc_form"
    
    /// `kyc_id_document`. Private. Filter mask: 4096.
    public static let kycIdDocument: String = "kyc_id_document"
    
    /// `kyc_poa`. Private. Filter mask: 8192.
    public static let kycPoa: String = "kyc_poa"
    
    /// `identity_mind_reject`. Private. Filter mask: 16384.
    public static let identityMindReject: String = "identity_mind_reject"
}
