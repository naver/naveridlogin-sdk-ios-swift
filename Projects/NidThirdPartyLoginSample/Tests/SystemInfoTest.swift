//
//  SystemInfoTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
import Foundation
@testable import NidLogin

struct SystemInfoTest {

    @Test("userAgent에 널 문자나 공백이 섞이지 않는지 확인한다.")
    func userAgentHasNoPadding() throws {
        let userAgent = SystemInfo().userAgent()

        #expect(!userAgent.contains("\0"))
        #expect(!userAgent.unicodeScalars.contains { $0.value < 0x20 })
    }

    @Test("userAgent가 약속된 형식을 지키는지 확인한다.")
    func userAgentFormat() throws {
        let userAgent = SystemInfo().userAgent()
        let fields = ["iOS/", "Model/", "OAuthLoginMod/"]

        for field in fields {
            #expect(userAgent.contains(field), "\(field) 가 없다: \(userAgent)")
        }
    }

    @Test("기기 모델명이 널 패딩 없이 실제 식별자만 담는지 확인한다.")
    func deviceModelIsIdentifierOnly() throws {
        let userAgent = SystemInfo().userAgent()
        let model = try #require(
            userAgent.split(separator: " ").first { $0.hasPrefix("Model/") }
        ).dropFirst("Model/".count)

        #expect(!model.isEmpty)
        // arm64, x86_64, iPhone17,1 처럼 ASCII 영숫자와 쉼표로만 이뤄진다.
        #expect(model.allSatisfy { $0.isASCII && ($0.isLetter || $0.isNumber || $0 == ",") })
    }
}
