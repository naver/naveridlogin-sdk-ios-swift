//
//  String+URLEncoding.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

extension String {
    func percentEncoded() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .allowedCharacterSet())
    }
}
