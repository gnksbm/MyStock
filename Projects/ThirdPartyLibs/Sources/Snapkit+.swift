//
//  Snapkit+.swift
//  ThirdPartyLibs
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import SnapKit

public extension ConstraintViewDSL {
    func equalTo(_ superView: UIView) {
        guard let view = target as? UIView else { return }
        superView.addSubview(view)
        
        makeConstraints { make in
            make.edges.equalTo(superView)
        }
    }
    
    func equalToSafeArea(_ superView: UIView) {
        guard let view = target as? UIView else { return }
        superView.addSubview(view)
        
        makeConstraints { make in
            make.edges.equalTo(superView.safeAreaLayoutGuide)
        }
    }
}
