//
//  NidSDKVersionTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
import Foundation
import NidCore

struct NidSDKVersionTest {

    @Test("NidSDKVersion.current와 NidCore 번들의 CFBundleShortVersionString이 일치하는지 확인한다.")
    func bundleVersionMatchesConstant() throws {
        let bundle = Bundle(for: NidLogger.self)
        let bundleVersion = try #require(bundle.infoDictionary?["CFBundleShortVersionString"] as? String)

        #expect(
            bundleVersion == NidSDKVersion.current,
            "번들 버전(\(bundleVersion))이 NidSDKVersion.current(\(NidSDKVersion.current))와 다릅니다. tuist clean manifests projectDescriptionHelpers && tuist generate 실행이 필요합니다."
        )
    }
}
