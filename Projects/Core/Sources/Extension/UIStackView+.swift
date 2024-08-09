//
//  UIStackView+.swift
//  Core
//
//  Created by gnksbm on 2/12/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public extension UIStackView {
    convenience init(
        spacing: CGFloat = 20,
        axis: NSLayoutConstraint.Axis = .horizontal,
        distribution: Distribution = .fill,
        alignment: Alignment = .fill,
        @TypeBuilder<UIView> views: () -> [UIView]
    ) {
        self.init()
        views().forEach { addArrangedSubview($0) }
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
    
    func addDivider(
        color: UIColor,
        hasPadding: Bool = false,
        dividerRatio: Double = 1
    ) {
        let subViewCount = arrangedSubviews.count
        var insertAt = 1
        if subViewCount > 1 {
            for _ in 1...subViewCount - 1 {
                let separator = UIView()
                separator.backgroundColor = color
                insertArrangedSubview(separator, at: insertAt)
                insertAt += 2
                switch axis {
                case .vertical:
                    NSLayoutConstraint.activate([
                        separator.heightAnchor.constraint(equalToConstant: 1),
                        separator.widthAnchor.constraint(
                            equalTo: self.widthAnchor, multiplier: dividerRatio
                        )
                    ])
                case .horizontal:
                    NSLayoutConstraint.activate([
                        separator.widthAnchor.constraint(equalToConstant: 1),
                        separator.heightAnchor.constraint(
                            equalTo: self.heightAnchor, multiplier: dividerRatio
                        )
                    ])
                @unknown default:
                    break
                }
            }
        }
        if hasPadding {
            insertArrangedSubview(UIView(), at: 0)
            insertArrangedSubview(UIView(), at: arrangedSubviews.count)
        }
    }
}
