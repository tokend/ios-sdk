import Foundation

/// KDF params model.
public struct KDFParams {
    
    /// KDF algorithm.
    /// - Note: Only `Scrypt` is supported currently.
    public let algorithm: String
    public let bits: Int64
    public let id: String
    public let n: UInt64
    public let p: UInt32
    public let r: UInt32
    public let type: String
    
    // MARK: - Public
    
    public init(
        algorithm: String,
        bits: Int64,
        id: String,
        n: UInt64,
        p: UInt32,
        r: UInt32,
        type: String
        ) {
        
        self.algorithm = algorithm
        self.bits = bits
        self.id = id
        self.n = n
        self.p = p
        self.r = r
        self.type = type
    }
    
    /// Checks input email for satisfying KDF version.
    /// - Parameters:
    ///   - email: Email string.
    /// > Input `email` string may be transformed depending on KDF `id` value:
    /// - **"1"**: Returns input email.
    /// - **"2"**: Returns lowercased email.
    /// - Returns: Checked email.
    public func checkedEmail(_ email: String) -> String {
        if self.id == "1" {
            return email
        } else if self.id == "2" {
            return email.lowercased()
        }
        return email
    }
}
