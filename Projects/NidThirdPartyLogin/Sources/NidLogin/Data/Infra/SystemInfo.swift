//
//  SystemInfo.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit
import NidCore

public final class SystemInfo {
    let currentModuleVersion: String

    public init() {
        self.currentModuleVersion = NidSDKVersion.current
    }

    private func deviceModelName() -> String? {
        var sysInfo = utsname()
        uname(&sysInfo)

        let model = withUnsafePointer(to: &sysInfo.machine) { pointer in
            pointer.withMemoryRebound(to: CChar.self, capacity: Int(_SYS_NAMELEN)) {
                String(validatingCString: $0)
            }
        }
        guard let model, !model.isEmpty else { return nil }
        return model
    }

    public func userAgent() -> String {
        let deviceModel = (deviceModelName() ?? UIDevice.current.model).replacingOccurrences(of: " ", with: "")
        let systemVersion = UIDevice.current.systemVersion.replacingOccurrences(of: " ", with: "")
        let appId = Bundle.main.bundleIdentifier ?? ""
        let infoDic = Bundle.main.infoDictionary
        let appBuildVersion = infoDic?["CFBundleVersion"] as? String ?? ""
        let ua = "iOS/\(systemVersion) Model/\(deviceModel) \(appId)/\(appBuildVersion) OAuthLoginMod/\(currentModuleVersion)"
        return ua
    }
}
