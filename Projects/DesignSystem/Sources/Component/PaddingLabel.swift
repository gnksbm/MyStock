//
//  PaddingLabel.swift
//  DesignSystem
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import SnapKit

@dynamicMemberLookup
public final class PaddingLabel: UIView {
    private let label = UILabel()
    
    public override var backgroundColor: UIColor? {
        willSet {
            label.backgroundColor = newValue
        }
    }
    
    public override var tintColor: UIColor! {
        willSet {
            label.textColor = newValue
        }
    }
    
    public init(
        inset: UIEdgeInsets
    ) {
        super.init(frame: .zero)
        configureLayout(with: inset)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<UILabel, Value>
    ) -> Value {
        get {
            label[keyPath: keyPath]
        }
        set {
            label[keyPath: keyPath] = newValue
        }
    }
    
    private func configureLayout(with inset: UIEdgeInsets) {
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(inset.top)
            make.leading.equalToSuperview().inset(inset.left)
            make.trailing.equalToSuperview().inset(inset.right)
            make.bottom.equalToSuperview().inset(inset.bottom)
        }
    }
}
