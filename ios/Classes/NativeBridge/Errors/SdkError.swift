import Flutter
import Foundation
import OneginiSDKiOS

class SdkError: Error {
    var code: Int
    var errorDescription: String
    var details: [String: Any?] = [:]

    // Only error codes
    init(code: Int, errorDescription: String) {
        self.code = code
        self.errorDescription = errorDescription

        setGenericDetails()
    }

    init(_ wrapperError: OneWelcomeWrapperError) {
        self.code = wrapperError.code()
        self.errorDescription = wrapperError.message()

        setGenericDetails()
    }

    // Error codes with userInfo
    init(code: Int, errorDescription: String, info: [String: Any?]?) {
        self.code = code
        self.errorDescription = errorDescription

        setGenericDetails()
        setInfoDetails(info)
    }

    init(_ wrapperError: OneWelcomeWrapperError, info: [String: Any?]?) {
        self.code = wrapperError.code()
        self.errorDescription = wrapperError.message()

        setGenericDetails()
        setInfoDetails(info)
    }

    // Error codes with httResponse information
    init(code: Int, errorDescription: String, response: ResourceResponse?, iosCode: Int? = nil, iosMessage: String? = nil) {
        self.code = code
        self.errorDescription = errorDescription

        setGenericDetails()
        setResponseDetails(response, iosCode, iosMessage)
    }

    init(_ wrapperError: OneWelcomeWrapperError, response: ResourceResponse?, iosCode: Int? = nil, iosMessage: String? = nil) {
        self.code = wrapperError.code()
        self.errorDescription = wrapperError.message()

        setGenericDetails()
        setResponseDetails(response, iosCode, iosMessage)
    }

    func flutterError() -> FlutterError {
        let error = FlutterError(code: "\(self.code)", message: self.errorDescription, details: details)

        return error
    }

    static func convertToFlutter(_ error: SdkError?) -> FlutterError {
        let error = error ?? SdkError(.genericError)
        return error.flutterError()
    }
}

private extension SdkError {
    func setGenericDetails() {
        details["code"] = String(code)
        details["message"] = errorDescription
    }

    func setInfoDetails(_ info: [String: Any?]?) {
        if info == nil {
            details["userInfo"] = [:]
        } else {
            details["userInfo"] = info
        }
    }

    func setResponseDetails(_ response: ResourceResponse?, _ iosCode: Int?, _ iosMessage: String?) {
        if response == nil {
            details["response"] = [String: Any?]()
        } else {
            details["response"] = response?.toJSON()
        }

        // Add potential native error information on top of wrapper error
        if iosCode != nil {
            details["iosCode"] = iosCode
        }

        if iosMessage != nil {
            details["iosMessage"] = iosMessage
        }
    }
}

private extension ResourceResponse {
    func toJSON() -> [String: Any?] {
        return ["statusCode": statusCode,
                "headers": allHeaderFields,
                "url": response.url?.absoluteString,
                "body": data != nil ? String(data: data!, encoding: .utf8) : nil
        ]
    }
}
