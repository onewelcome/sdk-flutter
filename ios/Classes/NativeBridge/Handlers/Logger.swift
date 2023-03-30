//
//  Logger.swift
//  onegini
//
//  Created by Patryk Gałach on 24/04/2021.
//

import Foundation

class Logger {

    enum LogType: String {
        case debug = "debug"
        case log = "log"
        case warning = "warning"
        case error = "error"
    }

    static var enable = true

    static func log(_ message: String, sender: Any? = nil, logType: LogType = .debug) {

        if !enable {
            return
        }

        var m: String = "[\(logType.rawValue)]"

        if let s = sender {
            m = "\(m)[\(type(of: s))]"
        }
        m = "\(m) \(message)"

#if DEBUG
        // prints all while in development
        print(m)
#else
        // limit logs for release
        if logType != .debug {
            print(m)
        }
#endif
    }

}
