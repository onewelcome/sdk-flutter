import Flutter

extension Error {
    var domain: String { return (self as NSError).domain }
    var code: Int { return (self as NSError).code }
    var userInfo: Dictionary<String, Any> { return (self as NSError).userInfo }
    var recoverySuggestion: String? { return (self as NSError).localizedRecoverySuggestion }
    
    func toJSON() -> Dictionary<String, Any?>? {
        return ["message": self.localizedDescription,
                "recoverySuggestion": self.recoverySuggestion,
                "code": self.code,
                "domain": self.domain,
                "userInfo": self.userInfo
        ]
    }
}

extension FlutterError {
    static func configure(customType: PluginCustomErrorType) -> FlutterError {
        return FlutterError(code: "\(customType.rawValue)", message: customType.message(), details: nil)
    }
    
    static func configure(error: Error?) -> FlutterError {
        guard let error = error else {
            return FlutterError.configure(customType: .newSomethingWentWrong)
        }
        
        return FlutterError(code: "\(error.code)", message: error.localizedDescription, details: error.toJSON())
    }
}
