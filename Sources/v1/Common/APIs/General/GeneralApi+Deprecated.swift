import Foundation
import DLJSONAPI

@available(*, deprecated)
public extension GeneralApi {
    
    @available(*, deprecated, renamed: "IdentitiesApi.RequestIdentitiesResult")
    typealias RequestIdentitiesResult<SpecificAttributes: Decodable> = IdentitiesApi.RequestIdentitiesResult<SpecificAttributes>
    @available(*, deprecated, renamed: "IdentitiesApi.RequestIdentitiesFilter")
    typealias RequestIdentitiesFilter = IdentitiesApi.RequestIdentitiesFilter
    /// Method sends request to get identities via login or accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestIdentitiesResult`
    /// - Parameters:
    ///   - filter: Filter which will be used to fetch identities.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.RequestIdentitiesResult`
    @available(*, deprecated, message: "Use IdentitiesApi instead")
    func requestIdentities<SpecificAttributes: Decodable>(
        filter: RequestIdentitiesFilter,
        completion: @escaping (_ result: RequestIdentitiesResult<SpecificAttributes>) -> Void
    ) {
        
        identitiesApi.requestIdentities(
            filter: filter,
            completion: completion
        )
    }
    
    @available(*, deprecated, renamed: "IdentitiesApi.AddIdentityResult")
    typealias AddIdentityResult<SpecificAttributes: Decodable> = IdentitiesApi.AddIdentityResult<SpecificAttributes>
    /// Method sends request to create new identity using phone number.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestAddIdentityResult`
    /// - Parameters:
    ///   - phoneNumber: New identity's phone number
    ///   - completion: Block that will be called when the result will be received.
    @available(*, deprecated, message: "Use IdentitiesApi instead")
    func addIdentity<SpecificAttributes: Decodable>(
        withPhoneNumber phoneNumber: String,
        completion: @escaping ((AddIdentityResult<SpecificAttributes>) -> Void)
    ) {
        
        identitiesApi.addIdentity(
            withPhoneNumber: phoneNumber,
            completion: completion
        )
    }
    
    @available(*, deprecated, renamed: "IdentitiesApi.DeleteIdentityResult")
    typealias DeleteIdentityResult = IdentitiesApi.DeleteIdentityResult
    /// Method sends request to create new identity using phone number.
    /// The result of request will be fetched in `completion` block as `GeneralApi.RequestDeleteIdentityResult`
    /// - Parameters:
    ///   - phoneNumber: Identity's accountId
    ///   - completion: Block that will be called when the result will be received.
    @discardableResult
    @available(*, deprecated, message: "Use IdentitiesApi instead")
    func deleteIdentity(
        for accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (DeleteIdentityResult) -> Void
    ) -> Cancelable {
        
        return identitiesApi.deleteIdentity(
            for: accountId,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    @available(*, deprecated, renamed: "IdentitiesApi.SetPhoneRequestResult")
    typealias SetPhoneRequestResult = IdentitiesApi.SetPhoneRequestResult
    /// Method sends request to set phone for account with given accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.SetPhoneRequestResult`
    /// - Parameters:
    ///   - accountId: Account id of account for which it is necessary to set phone.
    ///   - phone: Model that contains phone to be set.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.SetPhoneRequestResult`
    @available(*, deprecated, message: "Use IdentitiesApi instead")
    func requestSetPhone(
        accountId: String,
        phone: String,
        completion: @escaping (_ result: SetPhoneRequestResult) -> Void
        ) {
        
        identitiesApi.requestSetPhone(
            accountId: accountId,
            phone: phone,
            completion: completion
        )
    }
    
    @available(*, deprecated, renamed: "IdentitiesApi.SetTelegramRequestResult")
    typealias SetTelegramRequestResult = IdentitiesApi.SetTelegramRequestResult
    /// Method sends request to set telegram for account with given accountId.
    /// The result of request will be fetched in `completion` block as `GeneralApi.SetTelegramRequestResult`
    /// - Parameters:
    ///   - accountId: Account id of account for which it is necessary to set phone.
    ///   - telegram: Model that contains telegram to be set.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `GeneralApi.SetTelegramRequestResult`
    @available(*, deprecated, message: "Use IdentitiesApi instead")
    func requestSetTelegram(
        accountId: String,
        telegram: String,
        completion: @escaping (_ result: SetTelegramRequestResult) -> Void
        ) {
        
        identitiesApi.requestSetTelegram(
            accountId: accountId,
            telegram: telegram,
            completion: completion
        )
    }
}
