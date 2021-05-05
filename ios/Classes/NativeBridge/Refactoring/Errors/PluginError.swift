//
//  PluginError.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation

class PluginError: FlutterError {
    
    class func from(data error: Error) -> FlutterError {
        let domain = (error as NSError).domain
        let code: Int = (error as NSError).code
        let userInfo: Dictionary<String, Any> = (error as NSError).userInfo
        let localizedDescription = error.localizedDescription
        let recoverySuggestion = (error as NSError).localizedRecoverySuggestion ?? ""
        
        let details = ["title": "Error",
                       "message": localizedDescription,
                       "recoverySuggestion": recoverySuggestion,
                       "code": code,
                       "domain": domain,
                       "userInfo": userInfo] as [String : Any]
        
        let flutterError = FlutterError(code: "\(code)", message: localizedDescription, details: details)

        return flutterError
    }

    class func from(customType: PluginErrorType = .newSomethingWentWrong) -> FlutterError {
        let flutterError = FlutterError(code: "\(customType.rawValue)", message: customType.message(), details: nil)

        return flutterError
    }
}
