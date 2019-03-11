import Foundation

public struct UploadBlobModel {
    
    // MARK: - Public properties
    
    public let type: String
    public let attributes: JSON
    
    // MARK: -
    
    public init(type: String, attributes: JSON) {
        self.type = type
        self.attributes = attributes
    }
    
    public init?(json: JSON) {
        guard let data = json["data"] as? JSON else {
            return nil
        }
        
        guard let type = data["type"] as? String,
            let attributes = json["attributes"] as? JSON else {
            return nil
        }
        
        self.type = type
        self.attributes = attributes
    }
    
    // MARK: - Public
    
    public func requestJSON() -> JSON {
        var data = JSON()
        
        data["type"] = self.type
        data["attributes"] = self.attributes
        
        let json: JSON = [
            "data": data
        ]
        
        return json
    }
}
