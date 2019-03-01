import Foundation
import DLJSONAPI

extension JSONAPI {
    
    public enum LinksPage {
        case `self`
        case first
        case prev
        case next
        case last
    }
}

extension BaseApiRequestBuilderJSONAPI {
    
    public func buildRequestFromLinks(
        _ links: Links,
        page: JSONAPI.LinksPage,
        method: RequestMethod,
        bodyParameters: RequestBodyParameters? = nil,
        headers: RequestHeaders? = nil,
        shouldSign: Bool,
        sendDate: Date = Date(),
        completion: @escaping (_ request: JSONAPI.RequestModel?) -> Void
        ) {
        
        guard let buildModel = self.parseRequestBuildModel(
            links: links,
            page: page,
            method: method,
            bodyParameters: bodyParameters,
            headers: headers
            ) else {
                completion(nil)
                return
        }
        
        self.buildRequest(
            buildModel,
            shouldSign: shouldSign,
            sendDate: sendDate,
            completion: completion
        )
    }
    
    public func parseRequestBuildModel(
        links: Links,
        page: JSONAPI.LinksPage,
        method: RequestMethod,
        bodyParameters: RequestBodyParameters?,
        headers: RequestHeaders?
        ) -> JSONAPI.BaseRequestBuildModel? {
        
        let pageLink: Link?
        switch page {
        case .`self`: pageLink = links.aSelf
        case .first: pageLink = links.first
        case .prev: pageLink = links.prev
        case .next: pageLink = links.next
        case .last: pageLink = links.last
        }
        
        guard let link = pageLink else {
            return nil
        }
        
        let path: String = link.endpoint
        
        let parsedQeryItems = link.queryItems.compactMap { (queryItem) -> (key: String, value: String)? in
            guard let value = queryItem.value else { return nil }
            
            return (queryItem.name, value)
        }
        let queryParameters = RequestQueryParameters(
            parsedQeryItems,
            uniquingKeysWith: { (key1, _) -> String in
                return key1
        })
        
        let include: [String]? = nil // include will not be parsed and just included into query params
        
        let buildModel = JSONAPI.BaseRequestBuildModel(
            path: path,
            method: method,
            queryParameters: queryParameters,
            bodyParameters: bodyParameters,
            headers: headers,
            include: include,
            pagination: nil
        )
        
        return buildModel
    }
}
