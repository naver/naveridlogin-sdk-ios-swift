//
//  NetworkError.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public enum NetworkError: Error, LocalizedError, CustomStringConvertible {
    case urlSessionInternalError(error: Error)
    case decodingFailed(data: Data, to: Any.Type)
    case invalidResponse
    case invalidUrlOrPath(url: URL, path: String)
    case invalidQueryParams(queryParams: Parameters)
    case invalidHTTPBodyParams(bodyParams: Parameters)

    public var description: String {
        self.errorDescription ?? "Undefined"
    }

    public var errorDescription: String? {
        switch self {
        case .urlSessionInternalError(let error): return  "URLSession internal error. \nDetailed error description: \(error)"
        case .decodingFailed(let data, let expectedType):
            var text = "Decoding to \(expectedType) failed."
            if let dataString = String(data: data, encoding: .utf8) {
                text += "Data: \(dataString)"
            }
            return text
        case .invalidResponse: return "Invalid response from server"
        case .invalidUrlOrPath: return "Invalid URL or Path"
        case .invalidQueryParams: return "Invalid query parameters"
        case .invalidHTTPBodyParams: return "Invalid HTTP body parameters"
        }
    }
}
