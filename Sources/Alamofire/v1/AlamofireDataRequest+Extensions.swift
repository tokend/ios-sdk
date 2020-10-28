import Foundation
import Alamofire

extension DataRequest {
    /// @Returns - DataRequest
    /// completionHandler handles JSON Object T
    /// - Returns: `DataRequest`
    @discardableResult func responseObject<T: Decodable> (
        queue: DispatchQueue? = nil,
        _ type: T.Type,
        completionHandler: @escaping (DataResponse<T, AFError>) -> Void
        ) -> Self {

        return responseDecodable(
            of: type,
            queue: queue ?? .main,
            decoder: JSONCoders.snakeCaseDecoder,
            completionHandler: completionHandler
        )
    }
}
