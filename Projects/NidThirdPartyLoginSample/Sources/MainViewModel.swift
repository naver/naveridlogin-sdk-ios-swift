//
//  MainViewModel.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import Foundation
import NidThirdPartyLogin

enum SectionType {
    case mainSection
    case parameterSection
    case outputSection
}

struct Section {
    enum DescriptionType {
        case text
        case selection(Int)
    }

    struct ParamDescription {
        let paramName: String
        let description: CustomStringConvertible
        var descriptionType: DescriptionType

        init(_ paramName: String, _ description: CustomStringConvertible) {
            self.paramName = paramName
            self.description = description
            self.descriptionType = .text
        }

        init(_ paramName: String, _ description: CustomStringConvertible, _ descriptionType: DescriptionType) {
            self.paramName = paramName
            self.description = description
            self.descriptionType = descriptionType
        }
    }

    let title: String
    var values: [ParamDescription]?
    let sectionType: SectionType
}

protocol ViewModelDelegate: AnyObject {
    func outputDidChange(to: [Section])
    func showMessage(_ message: String)
}

final class MainViewModel {
    weak var delegate: ViewModelDelegate? {
        didSet {
            self.delegateDidSet()
        }
    }

    private var parameterSection: [Section] {
        didSet { self.parameterDidChange() }
    }

    private var _outputSection: [Section] = [] {
        didSet { delegate?.outputDidChange(to: outputSection) }
    }

    private var outputSection: [Section] {
        get { _outputSection }
        set {
            _outputSection = [Section(title: "Output", values: nil, sectionType: .mainSection)] + newValue
        }
    }

    private var loginPlatform: [(LoginBehavior, Bool)] = {
        var platforms = LoginBehavior.allCases.map { ($0, false) }
        platforms[2].1 = true
        return platforms
    }() {
        didSet {
            var platformOption = self.parameterSection[1].values![0]
            let index = loginPlatform.firstIndex(where: { $0.1 == true })!
            platformOption.descriptionType = .selection(index)
            self.parameterSection[1].values![0] = platformOption
        }
    }

    var sections: [Section] {
        return parameterSection + outputSection
    }

    init() {
        let clientInfo = ["NidClientID", "NidClientSecret", "NidAppName"].map {
            return Section.ParamDescription($0, Bundle.main.infoDictionary![$0] as! String)
        }

        self.parameterSection = [
            Section(title: "Parameters", values: nil, sectionType: .mainSection),
            Section(
                title: "Client Settings",
                values: [.init("Platform", loginPlatform.map { $0.0.rawValue }, .selection( loginPlatform.firstIndex { $0.1 == true }!))] + clientInfo,
                sectionType: .parameterSection
            )
        ]
    }

    // MARK: - Input
    func changeInParameter(forKey key: String, value: String) {
        var sections: [Section] = [Section(title: "Parameters", values: nil, sectionType: .mainSection)]
        sections += [
            Section(
                title: "Client Settings",
                values: parameterSection[1].values?.map { result in
                    return key == result.paramName ? .init(result.paramName, value) : .init(result.paramName, result.description)
                } ?? [],
                sectionType: .parameterSection
            )
        ]
        self.parameterSection = sections
    }

    func requestCurrentAccessToken() {
        guard let accessToken = NidOAuth.shared.accessToken else {
            outputSection = [
                Section(title: "Access Token", values: [.init("Value", "No Access Token")], sectionType: .outputSection)
            ]
            return
        }

        outputSection = [
            Section(
                title: "Access Token",
                values: [
                    .init("Value", accessToken.tokenString),
                    .init("Expires At", accessToken.expiresAt),
                    .init("Is Expired", accessToken.isExpired)],
                sectionType: .outputSection
            )
        ]
    }

    func requestCurrentRefreshToken() {
        guard let refreshToken = NidOAuth.shared.refreshToken else {
            outputSection = [
                Section(title: "Refresh Token", values: [.init("Value", "No Refresh Token")], sectionType: .outputSection)
            ]
            return
        }

        outputSection = [
            Section(
                title: "Refresh Token",
                values: [.init("Value", refreshToken.tokenString)],
                sectionType: .outputSection
            )
        ]
    }

    func requestLogin() {
        NidOAuth.shared.requestLogin { [weak self] result in
            switch result {
            case .success(let output):
                self?.updateLoginResult(output)
            case .failure(let error):
                self?.updateError(error)
            }
        }
    }

    func requestLogout() {
        NidOAuth.shared.logout()
        updateToSuccess(title: "로그아웃")
    }

    func requestDisconnection() {
        NidOAuth.shared.disconnect { [weak self] result in
            switch result {
            case .success:
                self?.updateToSuccess(title: "연동 해제")
            case .failure(let error):
                self?.updateError(error)
            }
        }
    }

    func requestVerifyAccessToken() {
        guard let accessToken = NidOAuth.shared.accessToken?.tokenString else {
            delegate?.showMessage("No Access Token!")
            return
        }

        NidOAuth.shared.verifyAccessToken(accessToken) { [weak self] result in
            switch result {
            case .success(let result): self?.outputSection = [Section(title: "Access Token Validation", values: [.init("Value", result)], sectionType: .parameterSection)]
            case .failure(let error): self?.updateError(error)
            }
        }
    }

    func requestReprompt() {
        NidOAuth.shared.repromptPermissions(callback: { [weak self] result in
            switch result {
            case .success(let result): self?.updateLoginResult(result)
            case .failure(let error): self?.updateError(error)
            }
        })
    }

    func requestReauthenticate() {
        NidOAuth.shared.reauthenticate(callback: { [weak self] result in
            switch result {
            case .success(let result): self?.updateLoginResult(result)
            case .failure(let error): self?.updateError(error)
            }
        })
    }

    func requestUserProfile() {
        guard let accessToken = NidOAuth.shared.accessToken?.tokenString else {
            delegate?.showMessage("No Access Token!")
            return
        }

        NidOAuth.shared.getUserProfile(accessToken: accessToken) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.outputSection = [Section(title: "User Profile", values: profile.map { .init($0.key, $0.value) }, sectionType: .outputSection)]
            case .failure(let error):
                self?.updateError(error)
            }
        }
    }

    func changeInLoginPlatform(to index: Int) {
        var loginPlatform = loginPlatform.map { ($0.0, false) }
        loginPlatform[index].1 = true
        self.loginPlatform = loginPlatform
    }
}

extension MainViewModel {
    private func parameterDidChange() {
        parameterSection[1].values?.forEach {
            if case Section.DescriptionType.selection(let index) = $0.descriptionType {
                NidOAuth.shared.setLoginBehavior(loginPlatform[index].0)
            }
        }
    }

    private func delegateDidSet() {
        let paramSection = parameterSection
        self.parameterSection = paramSection
    }

    private func updateLoginResult(_ result: LoginResult) {
        self.outputSection = [
            Section(title: "Access Token", values: [
                .init("Value", result.accessToken.tokenString),
                .init("Expires At", result.accessToken.expiresAt),
                .init("Is Expired", result.accessToken.isExpired)],
                    sectionType: .outputSection)
            ,
            Section(title: "Refresh Token", values: [
                .init("Value", result.refreshToken.tokenString)
            ], sectionType: .outputSection),
        ]
    }

    private func updateError(_ nidError: NidError) {
        self.outputSection = [Section(
            title: "Error",
            values: [.init("Error Description", nidError.errorDescription ?? "")],
            sectionType: .outputSection)]
    }

    private func updateToSuccess(title: String) {
        self.outputSection = [.init(title: title, values: [.init("Result", "Success")], sectionType: .outputSection)]
    }
}
