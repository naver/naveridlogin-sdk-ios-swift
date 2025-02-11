//
//  NidLogger.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
#if canImport(OSLog)
import OSLog
#endif

/// 콘솔 로깅에 사용
///
public enum LogLevel: Int, CustomStringConvertible {
    case debug, info, error

    public var description: String {
        switch self {
        case .debug: "debug"
        case .info: "info"
        case .error: "error"
        }
    }
}

public final class NidLogger {
    static var platform: LogPlatform = {
    #if canImport(OSLog)
    if #available(iOS 14.0, *) {
        return OSLogger()
    } else {
        return DefaultLogger()
    }
    #else
    return DefaultLogger()
    #endif
    }()

    public static func log(_ message: String, level: LogLevel = .debug) {
        platform.log(message, level: level)
    }

    public static func log(_ error: Error, level: LogLevel = .debug) {
        if error is LocalizedError {
            platform.log(error.localizedDescription, level: level)
        } else {
            platform.log("\(error)", level: level)
        }
    }

    public static func fatalError(_ message: String, file: StaticString = #file, line: UInt = #line) -> Never {
        Swift.fatalError("NidOAuth: \(message)", file: file, line: line)
    }

    public static func fatalError(_ error: Error, file: StaticString = #file, line: UInt = #line) -> Never {
        Swift.fatalError("NidOAuth: \(error.localizedDescription)", file: file, line: line)
    }
}

protocol LogPlatform {
    func log(_ message: String, level: LogLevel)
}

struct DefaultLogger: LogPlatform {
    var logLevel: LogLevel = {
        #if DEBUG
        return .debug
        #else
        return .info
        #endif
    }()

    func log(_ message: String, level: LogLevel) {
        guard level.rawValue >= logLevel.rawValue else { return }
        Swift.print("[NidOAuth: \(level.description)] \(message)")
    }
}

@available(iOS 14.0, *)
struct OSLogger: LogPlatform {
    private var subsystem: String = {
        return "NidThirdPartyLogin"
    }()

    func log(_ message: String, level: LogLevel) {
        let logger = Logger(subsystem: subsystem, category: "oauth")

        switch level {
        case .debug: logger.debug("[NidOAuth] \(message)")
        case .error: logger.error("[NidOAuth] \(message)")
        case .info: logger.info("[NidOAuth] \(message)")
        }
    }
}
