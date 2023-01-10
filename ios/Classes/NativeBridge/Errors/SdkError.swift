import Flutter
import Foundation
import OneginiSDKiOS

class SdkError {
    var title: String
    var errorDescription: String
    var code: Int
    var info: [String: Any?] = [:]
    var ongResponse: ONGResourceResponse? = nil
    var iosCode: Int? = nil
    var iosMessage: String? = nil

    init(title: String = "Error",
        errorDescription: String, code: Int = OneWelcomeWrapperError.generic.rawValue, info: [String: Any?] = [:], response: ONGResourceResponse? = nil) {
        self.title = title
        self.code = code
        self.errorDescription = errorDescription
        self.info = info
        self.ongResponse = response
    }
    
    init(wrapperError: OneWelcomeWrapperError, title: String = "Error", info: [String: Any?] = [:], response: ONGResourceResponse? = nil, iosCode: Int? = nil, iosMessage: String? = nil) {
        self.title = title
        self.code = wrapperError.rawValue
        self.errorDescription = wrapperError.message()
        self.info = info
        self.ongResponse = response
        self.iosCode = iosCode
        self.iosMessage = iosMessage
    }

    func toJSON() -> Dictionary<String, Any?>? {
        var result: Dictionary<String, Any?>? = ["title": title, "message": errorDescription, "code": code, "userInfo": info, "response": ongResponse?.toJSON()]

        // Add potential native error information on top of wrapper error
        if iosCode != nil {
            result?["iosCode"] = iosCode
        }

        if iosMessage != nil {
            result?["iosMessage"] = iosMessage
        }

        return result
    }

    func flutterError() -> FlutterError {
        let _error = FlutterError(code: "\(self.code)", message: self.errorDescription, details: self.toJSON())

        return _error
    }
    
    static func convertToFlutter(_ error: SdkError?) -> FlutterError {
        let _error = error ?? SdkError(wrapperError: .generic)
        return _error.flutterError()
    }
}
