//
//  Constant.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public struct Constant {
    public static let naverAppThirdLoginScheme = "naversearchthirdlogin" // version2
    public static let naverAppLoginVersion = "2"
    public static var naverAppAuthCodeRequestURLString = "\(Constant.naverAppThirdLoginScheme)://thirdPartyLogin"
    public static let naverAppIncomingURLPage = "thirdPartyLoginResult"
    public static let nidOAuth20BaseURL = URL(string: "https://nid.naver.com/oauth2.0/")!
    public static let nidOpenAPIBaseURL = URL(string: "https://openapi.naver.com/v1/nid/")!
    public static let nidOAuth20Path = "authorize"
    public static let keychainServiceName = "\(String(describing: Bundle.main.bundleIdentifier)).nidthirdpartylogin.keychainservice"
}
