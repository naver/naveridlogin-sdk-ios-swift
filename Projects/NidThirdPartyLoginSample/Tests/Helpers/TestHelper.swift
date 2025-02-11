//
//  TestHelper.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

struct TestHelper {
    static var isRunningOnSimulator: Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }
}
