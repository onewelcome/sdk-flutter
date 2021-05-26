import Foundation
import OneginiSDKiOS

extension Error {
    var domain: String { return (self as NSError).domain }
    var code: Int { return (self as NSError).code }
    var userInfo: Dictionary<String, Any> {
        get { return (self as NSError).userInfo }
        set {}
    }
}
