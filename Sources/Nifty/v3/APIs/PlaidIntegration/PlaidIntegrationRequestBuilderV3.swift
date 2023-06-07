//
//  PlaidIntegrationRequestBuilderV3.swift
//  da
//
//  Created by Jonikorjk on 07.06.2023.
//

import Foundation

public class PlaidIntegrationRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Private properties
    
    private let integrations: String = "integrations"
    private let identitySvc = "identity-svc"
    private let kycStatus = "kyc-status"
    private let startKyc = "start-kyc"
    
    // MARK: - Public
    
    public func buildInitKycRequest(
        bodyParameters: [String: Any],
        sendDate: Date = Date()
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = self.integrations/self.identitySvc/self.startKyc
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleBody(
                path: path,
                method: .post,
                bodyParameters: bodyParameters
            ),
            shouldSign: false,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    public func buildGetKycStatusRequest(
        accountId: String,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?)
    ) {
        let path = self.integrations/self.identitySvc/self.kycStatus/accountId
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simple(
                path: path,
                method: .get
            ),
            shouldSign: false,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    public func buildGetListKycStatuses(
        filters: PlaidIntegrationRequestFiletersV3,
        pagination: RequestPagination,
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {
        let path = self.integrations/self.identitySvc/self.kycStatus
        let queryParameters = self.buildFilterQueryItems(filters.filterItems)
        
        self.buildRequest(
            JSONAPI.BaseRequestBuildModel.simpleQueryPagination(
                path: path,
                method: .get,
                queryParameters: queryParameters,
                pagination: pagination
            ),
            shouldSign: false,
            sendDate: sendDate,
            completion: completion
        )
    }
}
