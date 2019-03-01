import Foundation

private class FakeClass {}

// swiftlint:disable force_try
extension Data {
    init(jsonFileName: String) {
        let path = Bundle(for: FakeClass.self).url(forResource: jsonFileName, withExtension: "json")!
        
        self = try! Data(contentsOf: path)
    }
}
// swiftlint:enable force_try
