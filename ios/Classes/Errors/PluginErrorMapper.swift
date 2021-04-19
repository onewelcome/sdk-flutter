//
//  PluginErrorMapper.swift
//  onegini
//
//  Created by Patryk Gałach on 19/04/2021.
//

import Foundation

enum PluginCustomErrorType: Int {
    case pluginInternalError = 8000
//    case configuration = 8001
    case invalidArguments = 8001
    case illegalArgument = 8002
    case profileNotRegistered = 8003
    case noUserAuthenticated = 8005
    case noSuchAuthenticator = 8006
    case createPinNotInProgress = 8007
    case providePinNotInProgress = 8008
    case fingerprintNotInProgress = 8009
    case invalidMobileAuthenticationMethod = 8010
    case ioException = 8011
    case incorrentPin = 8012
    case httpError = 8013
    
    // default case
    case newSomethingWentWrong = 400
    
    // error description
    func message() -> String {
        var message = ""
        
        switch self {
        case .pluginInternalError:
            message = "Onegini: Internal plugin error."
//        case .configuration:
//            message = "Configuration error."
        case .invalidArguments:
            message = "Onegini: invalid arguments for the called method."
        case .illegalArgument:
            message = "Onegini: invalid authentication method for resource fetch."
        case .profileNotRegistered:
            message = "Onegini: No registered user found."
        case .noUserAuthenticated:
            message = "Onegini: No user authenticated."
        case .noSuchAuthenticator:
            message = "Onegini: No such authenticator found."
        case .createPinNotInProgress:
            message = "Onegini: create pin called, but no registration in progress."
        case .providePinNotInProgress:
            message = "Onegini: provide pin called, but no pin authentication in progress."
        case .fingerprintNotInProgress:
            message = "Onegini: received reply for fingerprint authentication, but no fingerprint authentication in progress."
        case .invalidMobileAuthenticationMethod:
            message = "Onegini: Invalid mobile authentication method."
        case .ioException:
            message = "Onegini: Device token cannot be NULL."
        case .incorrentPin:
            message = "Onegini: Incorrect Pin. Check the maxFailureCount and remainingFailureCount properties for details."
        case .httpError:
            message = "Onegini: Could not parse HTTP response to JSON."
        default:
            message = "Onegini: Something went wrong."
        }
        
        return message
    }
}
