//
//  HeaderView.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

@objc protocol NidHeaderViewDelegate {
    func showAccessToken()
    func showRefreshToken()
    func requestLogin()
    func requestLogout()
    func requestDisconnection()
    func requestVerifyAccessToken()
    func requestReprompt()
    func requestReauthenticate()
    func requestUserProfile()
}

final class HeaderView: UIView {
    private let mainStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    private let firstStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    private let secondStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    private(set) lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(resource: .naverLoginButton), for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.requestLogin), for: .touchUpInside)
        return button
    }()

    private lazy var showCurrentAccessTokenButton: UIButton = {
        let button = DefaultButton(frame: .zero)
        button.setTitle("현재 AccesToken 보기", for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.showAccessToken), for: .touchUpInside)
        return button
    }()

    private lazy var showCurrentRefreshTokenButton: UIButton = {
        let button = DefaultButton(frame: .zero)
        button.setTitle("현재 RefreshToken 보기", for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.showRefreshToken), for: .touchUpInside)
        return button
    }()

    private lazy var logoutButton: UIButton = {
        let button = DefaultButton(frame: .zero)
        button.setTitle("로그아웃 수행하기", for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.requestLogout), for: .touchUpInside)
        return button
    }()

    private lazy var resetButton: UIButton = {
        let button = DefaultButton()
        button.setTitle("연동 해제", for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.requestDisconnection), for: .touchUpInside)
        return button
    }()

    private lazy var verifyAccessTokenButton: UIButton = {
        let button = DefaultButton()
        button.setTitle("액세스 토큰 유효성 검사", for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.requestVerifyAccessToken), for: .touchUpInside)
        return button
    }()

    private lazy var repromptButton: UIButton = {
        let button = DefaultButton()
        button.setTitle("재동의(reprompt)", for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.requestReprompt), for: .touchUpInside)
        return button
    }()

    private lazy var reauthenticateButton: UIButton = {
        let button = DefaultButton()
        button.setTitle("재인증(reauthenticate)", for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.requestReauthenticate), for: .touchUpInside)
        return button
    }()

    private lazy var userProfileButton: UIButton = {
        let button = DefaultButton()
        button.setTitle("프로필 정보 불러오기", for: .normal)
        button.addTarget(delegate, action: #selector(delegate?.requestUserProfile), for: .touchUpInside)
        return button
    }()

    weak var delegate: NidHeaderViewDelegate?

    private lazy var buttons: [UIButton] = [
        showCurrentAccessTokenButton,
        showCurrentRefreshTokenButton,
        logoutButton,
        resetButton,
        verifyAccessTokenButton,
        repromptButton,
        reauthenticateButton,
        userProfileButton
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        mainStackView.addArrangedSubview(firstStackView)
        mainStackView.addArrangedSubview(secondStackView)
        addSubview(loginButton)
        addSubview(mainStackView)

        for i in 0..<buttons.count {
            i % 2 == 0 ? firstStackView.addArrangedSubview(buttons[i]) : secondStackView.addArrangedSubview(buttons[i])
        }

        let aspectRatio = UIImage(resource: .naverLoginButton).size.width / UIImage(resource: .naverLoginButton).size.height

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalTo: loginButton.heightAnchor, multiplier: aspectRatio),
            mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
        ])
    }
}
