//
//  WebLoginProcess.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore

struct WebLoginProcess: LoginProcess {
    let clientID: String
    let clientSecret: String
    let urlScheme: String
    let state: String
    let authType: AuthType
}
