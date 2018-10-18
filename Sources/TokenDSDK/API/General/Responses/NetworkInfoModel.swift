import Foundation
import TokenDWallet

public struct NetworkInfoModel {
    
    public static let transactionExpirationSlack: UInt64 = 20 * 60
    public static let transactionSendSlack: UInt64 = 20 * 60
    
    public let networkParams: NetworkParams
    public let masterAccountId: String
    public let masterExchangeName: String
    public let txExpirationPeriod: UInt64
    public let networkTime: Int64
    public let requestTime: Date
    public let responseTime: Date
    
    // MARK: -
    
    public init?(
        networkPassphrase: String,
        masterAccountId: String,
        masterExchangeName: String,
        txExpirationPeriod: UInt64,
        networkTime: Int64,
        requestTime: Date,
        responseTime: Date
        ) {
        
        guard let networkParams = NetworkParams(passphrase: networkPassphrase) else {
            return nil
        }
        
        self.networkParams = networkParams
        self.masterAccountId = masterAccountId
        self.masterExchangeName = masterExchangeName
        self.txExpirationPeriod = txExpirationPeriod
        self.networkTime = networkTime
        self.requestTime = requestTime
        self.responseTime = responseTime
    }
    
    public init?(
        networkInfoResponse: NetworkInfoResponse,
        requestTime: Date,
        responseTime: Date
        ) {
        
        self.init(
            networkPassphrase: networkInfoResponse.networkPassphrase,
            masterAccountId: networkInfoResponse.masterAccountId,
            masterExchangeName: networkInfoResponse.masterExchangeName,
            txExpirationPeriod: networkInfoResponse.txExpirationPeriod,
            networkTime: networkInfoResponse.currentTime,
            requestTime: requestTime,
            responseTime: responseTime
        )
    }
    
    // MARK: - Public
    
    public func getAdjustedSendTime(sendDate: Date) -> Int64 {
        let timeDifference = self.getLocalToNetworkTimeDifference()
        let sendTime = Int64(sendDate.timeIntervalSince1970)
        
        let adjusted = sendTime - timeDifference
        
        return adjusted
    }
    
    public func getLocalToNetworkTimeDifference() -> Int64 {
        let requestTimeSeconds = Int64(self.requestTime.timeIntervalSince1970)
        let responseTimeSeconds = Int64(self.responseTime.timeIntervalSince1970)
        
        let requestHalfDuration: Int64 = (responseTimeSeconds - requestTimeSeconds) / 2
        let adjustedRequestTime = requestTimeSeconds + requestHalfDuration
        let timeDifference = adjustedRequestTime - self.networkTime
        
        return timeDifference
    }
    
    public func getTxBuilderParams(
        memo: TokenDWallet.Memo? = nil,
        salt: TokenDWallet.Salt? = nil,
        sendDate: Date
        ) -> TransactionBuilderParams {
        
        let adjustedSendTime = self.getAdjustedSendTime(sendDate: sendDate)
        let minTxTime: Int64 = adjustedSendTime - Int64(NetworkInfoModel.transactionSendSlack)
        let maxTxTime: Int64 = adjustedSendTime + self.checkedTransactionExpirationPeriod()
        
        let timeBounds = TimeBounds(
            minTime: UInt64(minTxTime),
            maxTime: UInt64(maxTxTime)
        )
        
        let txBuilderParams = TransactionBuilderParams(
            memo: memo,
            timeBounds: timeBounds,
            salt: salt
        )
        
        return txBuilderParams
    }
    
    private func checkedTransactionExpirationPeriod() -> Int64 {
        if self.txExpirationPeriod > NetworkInfoModel.transactionExpirationSlack * 2 {
            return Int64(self.txExpirationPeriod - NetworkInfoModel.transactionExpirationSlack)
        } else {
            return Int64(Double(self.txExpirationPeriod) * 0.8)
        }
    }
}
