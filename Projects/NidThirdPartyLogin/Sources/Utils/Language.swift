//
//  Language.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation

public struct Language {
    public static var current: String? {
        guard let currentLangs = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] else {
            return nil
        }

        let supportedLangs = ["ko", "en", "zn-Hans", "zn-Hant"]

        for lang in supportedLangs where currentLangs.contains(lang) {
            return lang
        }

        return currentLangs[safe: 0]
    }
}
