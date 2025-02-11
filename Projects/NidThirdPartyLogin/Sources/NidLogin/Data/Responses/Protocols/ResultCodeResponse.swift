//
//  ResultCodeResponse.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

protocol ResultCodeResponse {
    var resultCode: String { get }
    var message: String { get }
}
