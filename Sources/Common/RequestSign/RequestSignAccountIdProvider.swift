import Foundation
import DLCryptoKit
import TokenDWallet

public protocol RequestSignAccountIdProviderProtocol {
    
    func getAccountId(completion: @escaping (_ accountId: String?) -> Void)
}

public class UnsafeRequestSignAccountIdProvider: RequestSignAccountIdProviderProtocol {
    
    // MARK: - Private properties
    
    private let accountId: String
    
    // MARK: -
    
    public init(accountId: String) {
        self.accountId = accountId
    }
    
    // MARK: - RequestSignAccountIdProviderProtocol
    
    public func getAccountId(completion: @escaping (String?) -> Void) {
        completion(self.accountId)
    }
}

