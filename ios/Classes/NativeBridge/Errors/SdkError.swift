import Flutter
import Foundation

class SdkError {
    var title: String
    var errorDescription: String
    var recoverySuggestion: String
    var code: Int

    init(title: String = "Error", errorDescription: String, recoverySuggestion: String = "Please try again.", code: Int = 400) {
        self.title = title
        self.errorDescription = errorDescription
        self.recoverySuggestion = recoverySuggestion
        self.code = code
    }
    
    func toJSON() -> Dictionary<String, Any?> {
        return ["title": title, "errorDescription": errorDescription, "recoverySuggestion": recoverySuggestion, "code": code]
    }
    
    func flutterError() -> FlutterError {
        let _error = FlutterError(code: "\(self.code)", message: self.errorDescription, details: self.toJSON())

        return _error
    }
    
    static func convertToFlutter(_ error: SdkError?) -> FlutterError {
        let _error = error ?? SdkError(errorDescription: "Something went wrong.")
        return _error.flutterError()
    }
}
