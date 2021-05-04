//
//  BrowserRequestConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 25/04/2021.
//

import Foundation

protocol BrowserRequestConnectorProtocol {
    func addListener(listener: BrowserListener)
    func removeListener(listener: BrowserListener)
    
    func acceptUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

protocol BrowserListener: class {
    func acceptUrl(url: URL)
    func denyUrl()
}

class BrowserRequestConnector: BrowserRequestConnectorProtocol {
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    var browserListeners: [BrowserListener] = []
    
    func addListener(listener: BrowserListener) {
        browserListeners.append(listener)
    }
    
    func removeListener(listener: BrowserListener) {
        let index = browserListeners.firstIndex { (element) -> Bool in
            return element === listener
        }
        
        if let i = index {
            browserListeners.remove(at: i)
        }
    }
    
    func acceptUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var url: String?
        var typeValue: Int?
        
        if let arg = call.arguments as! [String: Any]? {
            url = arg[Constants.Parameters.url] as? String
            typeValue = arg["type"] as! Int?
        }
        
        var type: WebSignInType = .insideApp
        if let _typeValue = typeValue, let value = WebSignInType.init(rawValue: _typeValue) {
            type = value
        }
        
        guard let u = URL.init(string: url ?? "") else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .invalidArguments))
            result(nil)
            return
        }
        
        browserListeners.forEach { (listener) in
            listener.acceptUrl(url: u)
        }
        
        result(nil)
    }
    
    func denyUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        browserListeners.forEach { (listener) in
            listener.denyUrl()
        }
        
        result(nil)
    }
}
