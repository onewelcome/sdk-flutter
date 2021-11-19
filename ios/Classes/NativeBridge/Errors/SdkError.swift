import Flutter
import Foundation
import OneginiSDKiOS

class SdkError {
    var title: String
    var errorDescription: String
    var recoverySuggestion: String
    var code: Int
    var info: [String: Any?] = [:]
    var ongResponse: ONGResourceResponse? = nil

    init(title: String = "Error", errorDescription: String, recoverySuggestion: String = "Please try again.", code: Int = 400, info: [String: Any?] = [:], response: ONGResourceResponse? = nil) {
        self.title = title
        self.errorDescription = errorDescription
        self.recoverySuggestion = recoverySuggestion
        self.code = code
        self.info = info
        self.ongResponse = response
    }
    
    init(customType: OneginiErrorCustomType, title: String = "Error", recoverySuggestion: String = "Please try again.") {
        self.title = title
        self.errorDescription = customType.message()
        self.recoverySuggestion = recoverySuggestion
        self.code = customType.rawValue
    }
    
    func toJSON() -> Dictionary<String, Any?>? {
        return ["title": title, "message": errorDescription, "recoverySuggestion": recoverySuggestion, "code": code, "userInfo": info, "response": ongResponse?.toJSON()]
    }
    
    func flutterError() -> FlutterError {
        let _error = FlutterError(code: "\(self.code)", message: self.errorDescription, details: self.toJSON())

        return _error
    }
    
    static func convertToFlutter(_ error: SdkError?) -> FlutterError {
        let _error = error ?? SdkError(customType: .somethingWentWrong)
        return _error.flutterError()
    }
}
