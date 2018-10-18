import Foundation
import Alamofire

extension DataRequest {
    /// @Returns - DataRequest
    /// completionHandler handles JSON Object T
    /// - Returns: `DataRequest`
    @discardableResult func responseObject<T: Decodable> (
        queue: DispatchQueue? = nil,
        _ type: T.Type,
        completionHandler: @escaping (DataResponse<T>) -> Void
        ) -> Self {
        
        let responseSerializer = DataResponseSerializer<T> { (_, response, data, error) in
            if let err = error {
                return .failure(err)
            }
            
            let result = DataRequest.serializeResponseData(response: response, data: data, error: error)
            let jsonData: Data
            switch result {
            case .failure(let error):
                return .failure(error)
            case .success(let data):
                jsonData = data
            }
            
            // (1)- Json Decoder. Decodes the data object into expected type T
            // throws error when failes
            let decoder = JSONCoders.snakeCaseDecoder
            do {
                let decoded = try decoder.decode(T.self, from: jsonData)
                return .success(decoded)
            } catch let error {
                return .failure(error)
            }
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
