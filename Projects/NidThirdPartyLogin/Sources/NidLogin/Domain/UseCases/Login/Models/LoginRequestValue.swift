//
//  LoginRequestValue.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

public enum AuthType {
    case `default`
    case reauthenticate
    case reprompt

    var value: String? {
        switch self {
        case .default: return nil
        case .reprompt: return "reprompt"
        case .reauthenticate: return "reauthenticate"
        }
    }
}

public struct LoginRequestValue {
    let clientId: String
    let clientSecret: String
    let urlScheme: String
    let appName: String
    let authType: AuthType

    public init(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        appName: String,
        authType: AuthType = .default
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.urlScheme = urlScheme
        self.appName = appName
        self.authType = authType
    }
}
