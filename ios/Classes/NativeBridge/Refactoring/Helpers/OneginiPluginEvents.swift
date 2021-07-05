//
//  PluginEvents.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation

enum OneginiPluginEvents: String {
    case error = "eventError"
    case openPin = "eventOpenPin"
    case closePin = "eventClosePin"
    case handleRegisteredUrl = "eventHandleRegisteredUrl"
    case initRegistration = "initRegistration"
    case finishRegistration = "finishRegistration"
}
