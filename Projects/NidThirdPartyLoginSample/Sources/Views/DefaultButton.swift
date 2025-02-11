//
//  DefaultButton.swift
//
//  Naver ID Login SDK for iOS Swift
//  Copyright (c) 2025-present NAVER Corp.
//  Apache-2.0
//

import UIKit

final class DefaultButton: UIButton {
    struct Constant {
        static let naverGreenColor = UIColor(red: 3 / 255.0, green: 199 / 255.0, blue: 90 / 255.0, alpha: 1)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constant.naverGreenColor
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.titleTextAttributesTransformer =
           UIConfigurationTextAttributesTransformer { incoming in
                   var outgoing = incoming
                   outgoing.font = UIFont.boldSystemFont(ofSize: 14)
                   return outgoing
             }
            configuration.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            self.configuration = configuration
        } else {
            self.titleLabel?.font = .boldSystemFont(ofSize: 14)
            self.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
