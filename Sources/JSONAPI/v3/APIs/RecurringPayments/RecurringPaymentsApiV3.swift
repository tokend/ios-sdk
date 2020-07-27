import Foundation
import DLJSONAPI

/// Class provides functionality that allows to fetch recurring payments data
public class RecurringPaymentsApiV3: JSONAPI.BaseApi {

    // MARK: - Public properties

    public let requestBuilder: RecurringPaymentsRequestBuilderV3

    // MARK: -

    public required init(apiStack: JSONAPI.BaseApiStack) {
        self.requestBuilder = .init(
            builderStack: .fromApiStack(apiStack)
        )

        super.init(apiStack: apiStack)
    }

    // MARK: - Public

    /// Returns system info.
    /// - Parameters:
    ///  - completion: Block that will be called when the result will be received.
    ///  - result: Member of `Recpayments.ScheduledPaymentRecordResource`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestSystemInfo(
        completion: @escaping (_ result: RequestSingleResult<Recpayments.InfoResource>) -> Void
    ) -> Cancelable {

        let requestModel = self.requestBuilder.buildSystemInfoRequest()

        return self.requestSingle(
            Recpayments.InfoResource.self,
            request: requestModel,
            completion: { (result) in

                switch result {

                case .failure(let error):
                    completion(.failure(error))

                case .success(let document):
                    completion(.success(document))
                }
        })
    }


    public enum SchedulePaymentDestination {

        /// Destination card to send payment. If provided - `balanceId` MUST be binded to the card.
        case card(balanceId: String, cardNumber: String)

        /// Destination balance to send payment.
        case balance(balanceId: String)
    }
    /// Creates recurring payment.
    /// - Parameters:
    ///   - destination: Destination.
    ///   - sourceAccountId: Sender's balance account.
    ///   - sourceBalanceId: Sender's balance. Balance should be binded to the card.
    ///   - sourceCardNumber: Sender's card.
    ///   - amount: Amount.
    ///   - recurrenceRule: RFC5545-formatted string that describes recurrent rule.
    ///   - sendImmediately: Indicates whether the service should send payment immediately.
    ///   - subject: Subject of the recurring payment.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `Recpayments.ScheduledPaymentRecordResource`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestSchedulePayment(
        destination: SchedulePaymentDestination,
        sourceAccountId: String,
        sourceBalanceId: String,
        sourceCardNumber: String,
        amount: String,
        recurrenceRule: String,
        sendImmediately: Bool,
        subject: String,
        completion: @escaping (_ result: RequestSingleResult<Recpayments.ScheduledPaymentRecordResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        let request: SchedulePaymentRequest = .init(
            data: .init(
                attributes: .init(
                    destinationType: destination.destinationType,
                    amount: amount,
                    rRule: recurrenceRule,
                    sendImmediately: sendImmediately,
                    subject: subject
                ),
                relationships: .init(
                    sourceAccount: .init(
                        id: sourceAccountId,
                        type: "accounts"
                    ),
                    sourceBalance: .init(
                        id: sourceBalanceId,
                        type: "balances"
                    ),
                    sourceCard: .init(
                        id: sourceCardNumber,
                        type: "cards"
                    ),
                    destinationCard: destination.destinationCard,
                    destinationBalance: destination.destinationBalance
                )
            )
        )

        guard let encodedRequest = try? request.documentDictionary() else {
            completion(.failure(JSONAPIError.failedToBuildRequest))
            return cancelable
        }

        self.requestBuilder.buildSchedulePaymentRequest(
            bodyParameters: encodedRequest,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestSingle(
                    Recpayments.ScheduledPaymentRecordResource.self,
                    request: request,
                    completion: { (result) in

                        switch result {

                        case .failure(let error):
                            completion(.failure(error))

                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })

        return cancelable
    }

    /// Returns the list of recurring payments.
    /// - Parameters:
    ///   - filters: Request filters.
    ///   - include: Resource to include.
    ///   - pagination: Pagination option.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<Recpayments.ScheduledPaymentRecordResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestScheduledPayments(
        filters: RecurringPaymentsRequestsFilters,
        include: [String]?,
        pagination: RequestPagination,
        completion: @escaping (_ result: RequestCollectionResult<Recpayments.ScheduledPaymentRecordResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildScheduledPaymentsRequest(
            filters: filters,
            include: include,
            pagination: pagination,
            completion: { [weak self] (request) in
                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestCollection(
                    Recpayments.ScheduledPaymentRecordResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {

                        case .failure(let error):
                            completion(.failure(error))

                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })

        return cancelable
    }

    /// Returns the specified recurring payment.
    /// - Parameters:
    ///   - id: Identifier of payment to fetch.
    ///   - include: Resource of include.
    ///   - completion: Block that will be called when the result will be received.
    ///   - result: Member of `RequestCollectionResult<Recpayments.ScheduledPaymentRecordResource>`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestScheduledPayment(
        id: String,
        include: [String]?,
        completion: @escaping (_ result: RequestSingleResult<Recpayments.ScheduledPaymentRecordResource>) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildScheduledPaymentRequest(
            id: id,
            include: include,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestSingle(
                    Recpayments.ScheduledPaymentRecordResource.self,
                    request: request,
                    completion: { (result) in
                        switch result {

                        case .failure(let error):
                            completion(.failure(error))

                        case .success(let document):
                            completion(.success(document))
                        }
                })
        })

        return cancelable
    }

    /// Allows to stop recurrence of the payments.
    /// - Parameters:
    ///   - id: Recurrent payment's identifier.
    ///   - result: Member of `RequestEmptyResult`
    /// - Returns: `Cancelable`
    @discardableResult
    public func requestDeleteScheduledPayment(
        id: String,
        completion: @escaping (_ result: RequestEmptyResult) -> Void
    ) -> Cancelable {

        var cancelable = self.network.getEmptyCancelable()

        self.requestBuilder.buildDeleteScheduledPaymentRequest(
            id: id,
            completion: { [weak self] (request) in

                guard let request = request else {
                    completion(.failure(JSONAPIError.failedToSignRequest))
                    return
                }

                cancelable.cancelable = self?.requestEmpty(
                    request: request,
                    completion: { (result) in
                        switch result {

                        case .failure(let error):
                            completion(.failure(error))

                        case .success:
                            completion(.success)
                        }
                })
        })

        return cancelable
    }
}

private extension RecurringPaymentsApiV3.SchedulePaymentDestination {

    var destinationType: SchedulePaymentRequest.Attributes.DestinationType {

        switch self {

        case .balance:
            return .init(
                value: 1,
                name: "hate_you"
            )

        case .card:
            return .init(
                value: 2,
                name: "hate_you"
            )
        }
    }

    var destinationBalance: SchedulePaymentRequest.Relationships.Data {

        switch self {

        case .balance(let balanceId),
             .card(let balanceId, _):
            return .init(
                id: balanceId,
                type: "balances"
            )
        }
    }

    var destinationCard: SchedulePaymentRequest.Relationships.Data? {

        switch self {

        case .balance:
            return nil

        case .card(_, let cardNumber):
            return .init(
                id: cardNumber,
                type: "cards"
            )
        }
    }
}
