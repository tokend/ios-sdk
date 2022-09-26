import UIKit
import TokenDWallet

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = ApiExampleViewControllerV3()
        
        self.window?.rootViewController = vc
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

extension TokenDWallet.PublicKey {
    init?(
        base32EncodedString: String,
        expectedVersion: Base32Check.VersionByte
        ) {
        
        guard let data = try? Base32Check.decodeCheck(
            expectedVersion: expectedVersion,
            encoded: base32EncodedString
            ) else {
                return nil
        }
        
        var uint = Uint256()
        uint.wrapped = data
        self = .keyTypeEd25519(uint)
    }
}
