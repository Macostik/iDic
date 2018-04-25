//
//  BaseViewController.swift
//  BinarySwipe
//
//  Created by Macostik on 5/23/16.
//

import UIKit

extension UIApplicationState {
    func displayName() -> String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        case .background: return "in background"
        }
    }
}

struct Logger {
    
    static let logglyDestination = SlimLogglyDestination()
    
    static func configure() {
        Slim.addLogDestination(logglyDestination)
    }
    
    enum LogColor: String {
        case `default` = "fg255,255,255;"
        case yellow = "fg219,219,110;"
        case green = "fg96,255,209;"
        case red = "fg201,91,91;"
        case blue = "fg0,151,210;"
        case orange = "fg234,117,69;"
    }
    
    fileprivate static let Escape = "\u{001b}["
    
    static func debugLog(_ string: @autoclosure () -> String,
                         color: LogColor = .default,
                         filename: String = #file,
                         line: Int = #line) {
        #if DEBUG
            Slim.debug("\(Escape)\(color.rawValue)\n\(string())\n\n\(Escape);",
                filename: filename,
                line: line)
        #endif
    }
    
    static func log<T>(_ message: @autoclosure () -> T,
                       color: LogColor = .default,
                       filename: String = #file,
                       line: Int = #line) {
        #if DEBUG
            Slim.debug("\(Escape)\(color.rawValue)\n\(message())\n\n\(Escape);",
                filename: filename,
                line: line)
        #else
            Slim.info(message, filename: filename, line: line)
        #endif
    }
    
    static func error<T>(_ message: @autoclosure () -> T,
                         color: LogColor = .default,
                         filename: String = #file,
                         line: Int = #line) {
        log(message, color: .red, filename: filename, line: line)
    }
    
    static func warning<T>(_ message: @autoclosure () -> T,
                         color: LogColor = .default,
                         filename: String = #file,
                         line: Int = #line) {
        log(message, color: .orange, filename: filename, line: line)
    }
    
    static func debug<T>(_ message: @autoclosure () -> T,
                           color: LogColor = .default,
                           filename: String = #file,
                           line: Int = #line) {
        log(message, color: .green, filename: filename, line: line)
    }
    
    static func info<T>(_ message: @autoclosure () -> T,
                         color: LogColor = .default,
                         filename: String = #file,
                         line: Int = #line) {
        log(message, color: .blue, filename: filename, line: line)
    }
}
