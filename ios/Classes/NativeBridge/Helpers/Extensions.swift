import Foundation
import OneginiSDKiOS

extension String {
    static func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
          options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: json, options: options)
          if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
          }
        } catch {
            Logger.log("String.stringify.error: \(error)")
        }

        return ""
    }
    
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    static func userActionResult(data: Any?, userInfo: ONGCustomInfo?) -> String {
        var result = Dictionary<String, Any?>()
        result[Constants.Keys.userData] = data
        
        if let userInfo = userInfo {
            result[Constants.Keys.customInfo] = userInfo.toJson()
        }
        
        return String.stringify(json: result)
    }
}

extension ONGCustomInfo {
    func toJson() -> Dictionary<String, Any?> {
        return ["status": self.status, "data": self.data]
    }
}
