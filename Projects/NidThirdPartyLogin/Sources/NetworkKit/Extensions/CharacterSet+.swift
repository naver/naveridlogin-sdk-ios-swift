//
//  CharacterSet+.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

extension CharacterSet {
    public static func allowedCharacterSet() -> CharacterSet {
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "&+?=")
        return allowedCharacterSet
    }
}
