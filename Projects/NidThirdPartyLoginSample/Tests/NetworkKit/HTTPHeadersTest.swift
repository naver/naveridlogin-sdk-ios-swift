//
//  HTTPHeadersTest.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
@testable import NetworkKit
import Testing

struct HTTPHeadersTest {
    @Test
    func httpHeaderInitalizationTest() {
        let iOSHeader = HTTPHeader.userAgent("iOS")
        let AOSHeader = HTTPHeader.userAgent("AOS")
        let headers = HTTPHeaders([iOSHeader, AOSHeader])
        let header = headers.valueByKey(AOSHeader)
        #expect(header!.value == "AOS")
        #expect(headers.value(iOSHeader) == nil && headers.value(AOSHeader) != nil)
        #expect(!headers.contains(iOSHeader))
        #expect(headers.contains(AOSHeader))
        #expect(headers.containsByKey(iOSHeader) && headers.containsByKey(AOSHeader))
    }
}
