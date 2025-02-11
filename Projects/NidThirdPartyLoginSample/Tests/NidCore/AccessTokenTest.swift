//
//  AccessTokenTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
import Foundation
@testable import NidCore

struct AccessTokenTest {
    @Test
    func accessTokenExpirationTest() async {
        var components = DateComponents()
        components.year = 1990
        let date = Calendar.current.date(from: components)!

        let accessToken = NidCore.AccessToken(expiresAt: date, tokenString: "abcd")
        #expect(accessToken.isExpired)

        let accessToken2 = NidCore.AccessToken(expiresIn: 1, tokenString: "abcd")

        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                #expect(accessToken2.isExpired)
                continuation.resume()
            })
        }
    }

    @Test
    func accessTokenNotExpirationTest() {
        var components = DateComponents()
        components.year = 2999
        let date = Calendar.current.date(from: components)!

        let accessToken = NidCore.AccessToken(expiresAt: date, tokenString: "abcd")
        #expect(!accessToken.isExpired)

        let accessToken2 = NidCore.AccessToken(expiresIn: 1000, tokenString: "abcd")
        #expect(!accessToken2.isExpired)
    }
}
