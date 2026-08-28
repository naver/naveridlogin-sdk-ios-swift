//
//  AppAuthCodeRequestTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
import Foundation
@testable import NidLogin
import NetworkKit

struct AppAuthCodeRequestTest {

    @Test("네이버앱 로그인 요청 URL에 SDK 버전이 포함되는지 확인한다.")
    func extSdkVersionTest() throws {
        let request = AppAuthCodeRequest(
            parameters: .init(
                callbackScheme: "myapp",
                extOauthConsumerKey: "abcd",
                extAppName: "TestApp",
                authType: .default,
                extSdkVersion: "5.2.0"
            )
        )

        let url = try #require(URLGenerator.generateURL(request))
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = try #require(components.queryItems)

        #expect(queryItems.contains { $0.name == "extSdkVersion" && $0.value == "5.2.0" })
    }
}
