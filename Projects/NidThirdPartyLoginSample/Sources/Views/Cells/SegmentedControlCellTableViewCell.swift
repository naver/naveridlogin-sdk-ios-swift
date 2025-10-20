//
//  SegmentedControlCellTableViewCell.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//
import UIKit

class SegmentedControlCellTableViewCell: UITableViewCell {
    static let identifier = "SegmentedControlCellTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segmentedControl
    }()

    weak var delegate: SegmentedControlDelegate?

    private func configureLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])

        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        segmentedControl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        segmentedControl.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    public func setValues(title: String, _ values: [String], selection: Int) {
        self.titleLabel.text = title
        self.segmentedControl.removeAllSegments()
        for (idx, value) in values.enumerated() {
            self.segmentedControl.insertSegment(withTitle: value, at: idx, animated: false)
        }
        self.segmentedControl.selectedSegmentIndex = selection
    }

    @objc private func segmentChanged() {
        delegate?.didSelectSegment(segmentedControl.selectedSegmentIndex)
    }
}

@MainActor
protocol SegmentedControlDelegate: AnyObject {
    func didSelectSegment(_ index: Int)
}
