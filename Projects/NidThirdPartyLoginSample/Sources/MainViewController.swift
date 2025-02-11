//
//  MainViewController.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

final class MainViewController: UIViewController {
    private lazy var mainView = MainView(delegate: self)
    let viewModel: MainViewModel

    override func loadView() {
        self.view = mainView
    }

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setDelegates()
        setupTapGesture()
    }

    private func setDelegates() {
        mainView.tableView.dataSource = self
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MainViewController: NidHeaderViewDelegate {
    func showAccessToken() {
        viewModel.requestCurrentAccessToken()
    }
    
    func showRefreshToken() {
        viewModel.requestCurrentRefreshToken()
    }

    func requestLogin() {
        viewModel.requestLogin()
    }

    func requestLogout() {
        viewModel.requestLogout()
    }
    
    func requestDisconnection() {
        viewModel.requestDisconnection()
    }
    
    func requestVerifyAccessToken() {
        viewModel.requestVerifyAccessToken()
    }
    
    func requestReprompt() {
        viewModel.requestReprompt()
    }
    
    func requestReauthenticate() {
        viewModel.requestReauthenticate()
    }
    
    func requestUserProfile() {
        viewModel.requestUserProfile()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].values?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let values = viewModel.sections[indexPath.section].values!
        let descriptionType = viewModel.sections[indexPath.section].values![indexPath.row].descriptionType

        switch descriptionType {
        case .selection(let idx):
            let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlCellTableViewCell.identifier, for: indexPath) as! SegmentedControlCellTableViewCell
            let arr = values[indexPath.row].description as! [String]
            cell.delegate = self
            cell.setValues(title: values[indexPath.row].paramName, arr, selection: idx)
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
            cell.setValue(title: values[indexPath.row].paramName, description: values[indexPath.row].description, descriptionType: .normal)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
}

extension MainViewController: MainViewDelegate {
    var sections: [Section] {
        return viewModel.sections
    }
}

extension MainViewController: ViewModelDelegate {
    func outputDidChange(to: [Section]) {
        DispatchQueue.main.async { [weak self] in
            self?.mainView.tableView.reloadData()
        }
    }

    func showMessage(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.toastMessage(message)
        }
    }
}

extension MainViewController: SegmentedControlDelegate {
    func didSelectSegment(_ index: Int) {
        viewModel.changeInLoginPlatform(to: index)
    }
}
