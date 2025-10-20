//
//  MainView.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

@MainActor
protocol MainViewDelegate: AnyObject, NidHeaderViewDelegate {
    var sections: [Section] { get }
    var viewModel: MainViewModel { get }
}

final class MainView: UIView {
    struct Constant {
        static let mainSectionHeight: CGFloat = 30
        static let subSectionHeight: CGFloat = 30
        static let cellHeight: CGFloat = 40
    }

    // MARK: - Views
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemGray6
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
        headerView.delegate = delegate
        tableView.tableHeaderView = headerView
        return tableView
    }()

    // MARK: - Intializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: MainViewDelegate?

    init(delegate: MainViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        tableView.delegate = self
        registerCells()
        configureLayout()
    }

    private func registerCells() {
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.register(SegmentedControlCellTableViewCell.self, forCellReuseIdentifier: SegmentedControlCellTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
    }

    private func configureLayout() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

extension MainView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return Constant.cellHeight
//    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if delegate?.sections[section].sectionType == .mainSection {
            return Constant.mainSectionHeight
        } else {
            return Constant.subSectionHeight
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let delegate = delegate else { return nil }
        let headerView: SectionHeaderView!
        switch delegate.viewModel.sections[section].sectionType {
        case .mainSection:
            headerView = SectionHeaderView(size: .big)
        case .parameterSection, .outputSection:
            headerView = SectionHeaderView(size: .normal)
        }

        headerView.setTitle(delegate.viewModel.sections[section].title)
        return headerView
    }
}
