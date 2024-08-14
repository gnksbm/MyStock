//
//  UIViewController+.swift
//  DesignSystem
//
//  Created by gnksbm on 8/14/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public extension UIViewController {
    private enum OverlayHelper {
        static var activityView: UIActivityIndicatorView?
    }
    
    func showActivityIndicator() {
        guard OverlayHelper.activityView == nil else { return }
        let activityView = UIActivityIndicatorView()
        activityView.color = .tintColor
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.startAnimating()
        OverlayHelper.activityView = activityView
        view.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            activityView.centerYAnchor.constraint(
                equalTo: safeArea.centerYAnchor
            ),
        ])
        view.layoutIfNeeded()
    }
    
    func hideActivityIndicator() {
        OverlayHelper.activityView?.removeFromSuperview()
        OverlayHelper.activityView = nil
    }
}
