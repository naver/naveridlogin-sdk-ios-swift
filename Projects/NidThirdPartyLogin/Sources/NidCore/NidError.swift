//
//  NidError.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public enum NidError: Error, LocalizedError, CustomStringConvertible {
    case clientError(ClientErrorDetail)
    case serverError(ServerErrorDetail)

    public enum ClientErrorDetail {
        case initalizeNotCalled
        case missingClientConfiguration(key: String)
        case invalidClientConfigurationFormat
        case canceledByUser
        case unsupportedResponseType
        case naverAppNotInstalled

        public var errorDescription: String? {
            switch self {
            case .initalizeNotCalled: return "NidOAuth.initialize() should be called before using NidOAuth."
            case .missingClientConfiguration(let key): return "Missing \(key) in Info.plist. \nPlease check your configuration."
            case .invalidClientConfigurationFormat: return "Client configuration format is invalid. \nPlease check if your configuration is in correct format."
            case .canceledByUser: return "User canceled the request."
            case .unsupportedResponseType: return "Unsupported response type."
            case .naverAppNotInstalled: return "Naver app is not installed. \nPlease install Naver App to authenticate using Naver App."
            }
        }
    }

    public enum ServerErrorDetail {
        case invalidState(expected: String, actual: String?)
        case invalidURLResponse(URL)
        case invalidResponseFormat // 디코딩은 성공했지만, 유효하지 않은 response format으로 내려오는 경우
        case networkError(Error?)
        case webAuthenticationInternalError(Error?)
        case authError(errorCode: String, errorDescription: String?)

        public var errorDescription: String? {
            switch self {
            case .invalidState(let expected, let actual): return "State not matched. \nExpected \(expected), but got \(actual ?? "Null")"
            case .invalidURLResponse(let url): return "Invalid URL Response. \nURL: \(url)"
            case .invalidResponseFormat: return "Response is not in valid format."
            case .networkError(let error):
                let errorDescription: String = error != nil ? String(describing: error!) : "Not given"
                return "Network error. Detailed error description: \(errorDescription)"
            case .webAuthenticationInternalError(let error):
                let errorDescription: String = error != nil ? String(describing: error!) : "Not given"
                return "ASWebAuthentication internal error. \nDetailed error description: \(errorDescription))"
            case .authError(let errorCode, let errorDescription): return "NID given Error. Error Code: \(errorCode). \nError Description: \(errorDescription ?? "Not given")"
            }
        }
    }

    public var description: String {
        return errorDescription ?? "Undefined"
    }

    public var errorDescription: String? {
        switch self {
        case .clientError(let detail):
            return detail.errorDescription
        case .serverError(let detail):
            return detail.errorDescription
        }
    }
}
