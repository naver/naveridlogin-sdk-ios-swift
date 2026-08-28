//
//  UIApplication+.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

extension UIApplication {
    package static func activeWindowScene() -> UIWindowScene? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }

    package static func keyWindow() -> UIWindow? {
        return activeWindowScene()?.keyWindow
    }

    package func canOpenURLScheme(_ urlScheme: String) -> Bool {
        guard let url = URL(string: urlScheme) else { return false }
        return self.canOpenURL(url)
    }
}
