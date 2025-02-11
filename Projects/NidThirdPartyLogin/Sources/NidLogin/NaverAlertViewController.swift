//
//  NaverAlertViewController.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

public final class NaverAlertViewController: UIAlertController {
    public static func alertView(message: String, okTitle: String, cancelTitle: String, okAction: @escaping () -> Void, cancelAction: @escaping () -> Void) -> NaverAlertViewController {
        let alertVC = NaverAlertViewController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(cancelActionWithTitle(title: cancelTitle, completion: cancelAction))
        alertVC.addAction(okActionWithTitle(title: okTitle, completion: okAction))
        return alertVC
    }

    private static func cancelActionWithTitle(title: String, completion: @escaping (() -> Void)) -> UIAlertAction {
        let cancelAction = UIAlertAction(title: title, style: .cancel, handler: { _ in
            completion()
        })
        return cancelAction
    }

    private static func okActionWithTitle(title: String, completion: @escaping () -> Void) -> UIAlertAction {
        let okAction = UIAlertAction(title: title, style: .default, handler: { _ in
            completion()
        })
        return okAction
    }

    private var alertWindow: UIWindow?

    public func show() {
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first

        if let windowScene = windowScene as? UIWindowScene {
            self.alertWindow = UIWindow(windowScene: windowScene)
        }

        self.alertWindow?.frame = UIScreen.main.bounds
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.rootViewController?.view.backgroundColor = .clear
        alertWindow?.windowLevel = UIWindow.Level.alert + 1
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.alertWindow?.isHidden = true
        self.alertWindow = nil
    }
}
