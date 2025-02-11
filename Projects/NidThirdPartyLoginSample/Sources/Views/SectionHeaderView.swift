//
//  SectionHeaderView.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

final class SectionHeaderView: UIView {
    enum Size {
        case big
        case normal
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        if self.size == .big {
            label.font = .systemFont(ofSize: 20, weight: .bold)
        } else {
            label.font = .systemFont(ofSize: 16)
        }
        return label
    }()

    let size: Size

    init(size: Size) {
        self.size = size
        super.init(frame: .zero)
        self.backgroundColor = .systemGray5
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }

    public func setTitle(_ title: String) {
        label.text = title
    }
}
