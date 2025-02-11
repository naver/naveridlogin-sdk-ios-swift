//
//  DefaultAppAuthorizationCodeRepository.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit
import NidCore
import Utils
import NetworkKit

final class DefaultAppAuthorizationCodeRepository: AppAuthorizationCodeRepository {
    struct NaverAppNotInstalledDetail {
        static let message = "네이버 앱을 설치하면\n이용할 수 있는 서비스입니다."
        static let okTitle = "설치"
        static let cancelTitle = "취소"
        static let urlForNaverAppStore = "itms-apps://itunes.apple.com/app/id393499958"
    }

    func requestAuthCode(
        clientId: String,
        clientSecret: String,
        urlScheme: String,
        appName: String,
        authType: AuthType,
        callback: @escaping (NidError) -> Void) {
        let authCodeRequest = AppAuthCodeRequest(
            parameters: .init(
                callbackScheme: urlScheme,
                extOauthConsumerKey: clientId,
                extAppName: appName,
                authType: authType
            )
        )

        guard let authCodeRequestURL = URLGenerator.generateURL(authCodeRequest) else {
            return callback(NidError.clientError(.invalidClientConfigurationFormat))
        }

        UIApplication.shared.open(authCodeRequestURL) { naverAppOpened in
            if !naverAppOpened {
                let alertVC = NaverAlertViewController.alertView(
                    message: NaverAppNotInstalledDetail.message,
                    okTitle: NaverAppNotInstalledDetail.okTitle,
                    cancelTitle: NaverAppNotInstalledDetail.cancelTitle,
                    okAction: {
                        guard let appStoreUrl = URL(string: NaverAppNotInstalledDetail.urlForNaverAppStore) else {
                            return
                        }
                        UIApplication.shared.open(appStoreUrl, options: [:], completionHandler: nil)
                    },
                    cancelAction: {}
                )
                alertVC.show()
                callback(NidError.clientError(.naverAppNotInstalled))
            }
        }
    }
}
