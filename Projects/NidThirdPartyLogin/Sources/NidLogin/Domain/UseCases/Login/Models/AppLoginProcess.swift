//
//  AppLoginProcess.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import NidCore
import UIKit

struct AppLoginProcess: LoginProcess {
    let clientID: String
    let clientSecret: String
    let urlScheme: String
    let appName: String
    let authType: AuthType
    weak var presentingViewController: UIViewController?
}
