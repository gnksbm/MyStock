//
//  DescriptionView.swift
//  DesignSystem
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import FeatureDependency

public final class DescriptionView: BaseView {
    private let titleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let valueLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    public init(title: String, titleColor: UIColor) {
        super.init()
        titleLabel.text = title
        titleLabel.textColor = titleColor
    }
    
    public func updateValue(_ value: String) {
        valueLabel.text = value
    }
    
    override public func configureLayout() {
        [titleLabel, valueLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.horizontalEdges.equalTo(self)
        }
    }
}
