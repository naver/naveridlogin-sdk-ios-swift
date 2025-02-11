//
//  LoginBehavior.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

public enum LoginBehavior: String, CaseIterable {
    case app = "Naver App"
    case inAppBrowser = "In App Browser"
    case appPreferredWithInAppBrowserFallback = "App Preferred" // app이 설치된 경우 app으로, 설치되지 않은 경우 web으로 로그인
}
