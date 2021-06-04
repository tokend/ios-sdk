import Foundation

public enum BlobType: String {
    
    /// `asset_description`. Public. Filter mask: 1.
    case assetDescription = "asset_description"
    
    /// `fund_overview`. Public. Filter mask: 2.
    case fundOverview = "fund_overview"
    
    /// `fund_update`. Public. Filter mask: 4.
    case fundUpdate = "fund_update"
    
    /// `nav_update`. Public. Filter mask: 8.
    case navUpdate = "nav_update"
    
    /// `fund_document`. Public. Filter mask: 16.
    case fundDocument = "fund_document"
    
    /// `alpha`. Public. Filter mask: 32.
    case alpha = "alpha"
    
    /// `bravo`. Public. Filter mask: 64.
    case bravo = "bravo"
    
    /// `charlie`. Public. Filter mask: 128.
    case charlie = "charlie"
    
    /// `delta`. Public. Filter mask: 256.
    case delta = "delta"
    
    /// `token_terms`. Public. Filter mask: 512.
    case tokenTerms = "token_terms"
    
    /// `token_metrics`. Public. Filter mask: 1024.
    case tokenMetrics = "token_metrics"
    
    /// `kyc_form`. Private. Filter mask: 2048.
    case kycForm = "kyc_form"
    
    /// `kyc_id_document`. Private. Filter mask: 4096.
    case kycIdDocument = "kyc_id_document"
    
    /// `kyc_poa`. Private. Filter mask: 8192.
    case kycPoa = "kyc_poa"
    
    /// `identity_mind_reject`. Private. Filter mask: 16384.
    case identityMindReject = "identity_mind_reject"
}
