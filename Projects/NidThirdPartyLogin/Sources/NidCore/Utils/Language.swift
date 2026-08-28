//
//  Language.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

package struct Language {
    private static let supportedLangs = ["ko", "en", "ja", "vi", "zh-Hans", "zh-Hant"]

    package static var current: String? {
        guard let currentLangs = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] else {
            return nil
        }

        for lang in currentLangs {
            if let supportedLang = supportedLangs.first(where: { lang == $0 || lang.hasPrefix("\($0)-") }) {
                return supportedLang
            }
        }

        return currentLangs[safe: 0]
    }
}
