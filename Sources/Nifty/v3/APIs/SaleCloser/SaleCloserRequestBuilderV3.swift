//
//  SaleCloserRequestBuilderV3.swift
//  Alamofire
//
//  Created by Oksana Didusenko on 07.10.2022.
//

import Foundation

/// Class provides functionality that allows to build requests
/// which are used to fetch lp provider signer data
public class SaleCloserRequestBuilderV3: JSONAPI.BaseApiRequestBuilder {
    
    // MARK: - Public properties
    
    private var integrations: String { "integrations" }
    private var saleCloser: String { "sale-closer" }
    private var lpProviderSigner: String { "lp-provider-signer" }
    
    // MARK: - Public
    
    public func buildLPSignerRequest(
        sendDate: Date = Date(),
        completion: @escaping (JSONAPI.RequestModel?) -> Void
    ) {

        let path = self.integrations/self.saleCloser/self.lpProviderSigner

        self.buildRequest(
            .init(
                path: path,
                method: .get
            ),
            shouldSign: true,
            sendDate: sendDate,
            completion: completion
        )
    }
}
