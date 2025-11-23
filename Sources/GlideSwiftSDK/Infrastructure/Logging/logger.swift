//
//  Logger.swift
//  GlideSwiftSDK
//
//  Created by amir avisar on 19/11/2025.
//

import Foundation

let logger = AppLogger()

public enum LogLevel: Int, Comparable {
    case none = 0
    case error = 1
    case info = 2
    case verbose = 3
    case debug = 4
    
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    fileprivate var displayString: String {
        switch self {
        case .none: return ""
        case .error: return "❌ ERROR"
        case .info: return "ℹ️ INFO"
        case .verbose: return "🔍 VERBOSE"
        case .debug: return "🐛 DEBUG"
        }
    }
}

class AppLogger {
    private var currentLogLevel: LogLevel = .info
    
    func setLogLevel(_ level: LogLevel) {
        currentLogLevel = level
    }

    private func log(message: String, level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        guard level <= currentLogLevel else { return }
        guard level != .none else { return }
        
        let filename = (file as NSString).lastPathComponent
        print("\(level.displayString): [\(filename):\(line)] \(function) -> \(message)")
    }

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message: message, level: .error, file: file, function: function, line: line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message: message, level: .info, file: file, function: function, line: line)
    }

    func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message: message, level: .verbose, file: file, function: function, line: line)
    }

    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        log(message: message, level: .debug, file: file, function: function, line: line)
        #endif
    }
}
