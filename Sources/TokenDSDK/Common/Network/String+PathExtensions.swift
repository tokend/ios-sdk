import Foundation

extension String {
    func addPath(_ section: String) -> String {
        return self.getTrailingSlashChecked().appending("\(section)")
    }
    
    func addPath(_ section: Int) -> String {
        return self.getTrailingSlashChecked().appending("\(section)")
    }
    
    func getTrailingSlashChecked() -> String {
        if self.hasSuffix("/") {
            return self
        } else {
            return self.appending("/")
        }
    }
    
    func addParam(key: String, value: String) -> String {
        let prefix = self.contains("?") ? "&" : "?"
        return self.appending("\(prefix)\(key)=\(value)")
    }
}
