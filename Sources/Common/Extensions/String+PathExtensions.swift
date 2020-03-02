import Foundation

prefix operator /

extension String {
    
    public static prefix func / (right: String) -> String {
        return "".addPath(right)
    }
    
    public static func / (left: String, right: String) -> String {
        return left.addPath(right)
    }
    
    public func addPath(_ section: String) -> String {
        return self.getTrailingSlashChecked().appending(section.getLeadingSlashTrimmed())
    }
    
    public func addPath(_ section: Int) -> String {
        return self.getTrailingSlashChecked().appending("\(section)")
    }
    
    public func getTrailingSlashChecked() -> String {
        if self.hasSuffix("/") {
            return self
        } else {
            return self.appending("/")
        }
    }
    
    public func getLeadingSlashTrimmed() -> String {
        guard !self.isEmpty else { return self }
        
        if self.hasPrefix("/") {
            return String(self.dropFirst())
        } else {
            return self
        }
    }
    
    public func getTrailingSlashTrimmed() -> String {
        guard !self.isEmpty else { return self }
        
        if self.hasSuffix("/") {
            return String(self.dropLast())
        } else {
            return self
        }
    }
    
    public func addParam(key: String, value: String) -> String {
        let prefix = self.contains("?") ? "&" : "?"
        return self.appending("\(prefix)\(key)=\(value)")
    }
}
