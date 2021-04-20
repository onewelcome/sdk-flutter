//
//  RegistrationConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 17/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol RegistrationConnectorProtocol: FlutterNotificationReceiverProtocol {
    func register(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func createPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getUserProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func isUserRegistered(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancelFlow(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func respondToRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class NewRegistrationConnector: NSObject, RegistrationConnectorProtocol {
    
    var wrapper: RegistrationWrapperProtocol
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    init(registrationWrapper: RegistrationWrapperProtocol) {
        wrapper = registrationWrapper
        super.init()
        
        wrapper.notificationReceiver = self
    }
    
    func register(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        var identifier: String?
        var scopes: Array<String>?
        
        if let arg = call.arguments as! [String: Any]? {
            identifier = arg[Constants.Parameters.identityProviderId] as? String
            scopes = arg[Constants.Parameters.scopes] as? Array<String>
        }
        
        wrapper.register(providerId: identifier, scopes: scopes, completion: { (_, userProfile, error) -> Void in
            
            if let userProfile = userProfile {
                result(userProfile.profileId)
            } else {
                result(SdkError.convertToFlutter(error))
            }
        })
    }
    
    func createPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var pin: String?
        if let arg = call.arguments as! [String: Any]? {
            pin = arg[Constants.Parameters.identityProviderId] as? String
        }
        
        if let pin = pin {
            wrapper.createPin(pin: pin)
            result(nil)
        } else {
            result(SdkError.init(customType: .invalidArguments))
        }
    }
    
    func isUserRegistered(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var profileId: String?
        if let arg = call.arguments as! [String: Any]? {
            profileId = arg[Constants.Parameters.profileId] as? String
        }
        
        if let profileId = profileId {
            let isRegistered = wrapper.isUserRegistered(userId: profileId)
            result(isRegistered)
        } else {
            result(SdkError.init(customType: .invalidArguments))
        }
    }
    
    func getUserProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let profiles = wrapper.getUserProfiles()
        result(profiles)
    }
    
    func cancelFlow(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        wrapper.cancelFlow()
        result(nil)
    }
    
    func respondToRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
}

extension NewRegistrationConnector: RegistrationNotificationReceiverProtocol {
    func sendNotification(event: RegistrationNotification, eventData: Any?, error: SdkError?) {
        if let error = error {
            var data: [String: Any?] = [:]
            data[Constants.Parameters.eventName] = RegistrationNotification.eventError.rawValue
            data[Constants.Parameters.eventValue] = error.toJSON()
            
            flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: String.stringify(json: data))
        } else {
            var data: [String: Any?] = [:]
            data[Constants.Parameters.eventName] = event.rawValue
            if let eventData = eventData {
                data[Constants.Parameters.eventValue] = String.stringify(json: eventData)
            }
            
            flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: data)
        }
    }
}
