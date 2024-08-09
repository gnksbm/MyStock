//
//  BaseView.swift
//  FeatureDependency
//
//  Created by gnksbm on 8/9/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

open class BaseView: UIView {
    public init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configureUI() { }
    open func configureLayout() { }
}
