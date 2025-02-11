//
//  NidLoggerTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Testing
import Foundation
import UIKit
@testable import NidCore

struct NidLoggerTest {
    
    @Test
    func checkLogPlatform() {
        if #available(iOS 14.0, *) {
            #expect(NidLogger.platform is OSLogger)
        } else {
            #expect(NidLogger.platform is DefaultLogger)
        }
    }
}
