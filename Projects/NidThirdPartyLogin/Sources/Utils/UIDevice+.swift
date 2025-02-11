//
//  UIDevice+.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

public extension UIDevice {
    static var currentOS: String {
        return "IOS\(UIDevice.current.systemVersion)".replacingOccurrences(of: " ", with: "")
    }
}
