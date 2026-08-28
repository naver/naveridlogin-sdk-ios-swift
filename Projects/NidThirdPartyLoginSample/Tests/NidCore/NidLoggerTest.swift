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
        #expect(NidLogger.platform is OSLogger)
    }
}
