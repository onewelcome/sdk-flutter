import OneginiSDKiOS

extension Error {
    var domain: String { return (self as NSError).domain }
    var code: Int { return (self as NSError).code }
    var userInfo: Dictionary<String, Any> { return (self as NSError).userInfo }
}

extension ONGResourceResponse {
    func toJSON() -> Dictionary<String, Any?> {
        return ["statusCode": statusCode, "headers": allHeaderFields]
    }
}
