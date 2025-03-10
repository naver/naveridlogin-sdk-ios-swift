//
//  SystemInfo.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

public final class SystemInfo {
    let currentModuleVersion: String
    let defaultModuleVersion: String = "5.0.1"

    // XCFramework, Cocoapods binary의 경우
    public init(mainEntryModel: AnyClass) {
        self.currentModuleVersion = Bundle(for: mainEntryModel).infoDictionary?["CFBundleShortVersionString"] as? String ?? defaultModuleVersion
    }

    // SPM인 경우
    public init(bundle: Bundle) {
        if let plistPath = bundle.path(forResource: "NidThirdPartyLogin-Info", ofType: "plist"),
           let plistData = FileManager.default.contents(atPath: plistPath),
           let plist = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any] {
            self.currentModuleVersion = plist["CFBundleShortVersionString"] as? String ?? defaultModuleVersion
        } else {
            self.currentModuleVersion = defaultModuleVersion
        }
    }

    private func deviceModelName() -> String? {
        var sysInfo = utsname()
        uname(&sysInfo)
        let mirror = Mirror(reflecting: sysInfo.machine)
        let identifier = mirror.children.reduce("") { partialResult, element in
            guard let value = element.value as? Int8, value != 0 else { return partialResult }
            return partialResult + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
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
