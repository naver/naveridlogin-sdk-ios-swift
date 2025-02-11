//
//  SystemInfo.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

public final class SystemInfo {
    private let currentModuleVersion: String
    public init(mainEntryModel: AnyClass) {
        self.currentModuleVersion = Bundle(for: mainEntryModel).infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    private func deviceModelName() -> String? {
        var systemInfo = utsname()
        uname(&systemInfo)

        let model = withUnsafePointer(to: &systemInfo.machine) { (pointer) -> String in
            let data = Data(bytes: pointer, count: Int(_SYS_NAMELEN))
            return String(data: data, encoding: .utf8) ?? "Unknown"
        }

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
