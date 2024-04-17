//
//  UIViewController+.swift
//  Core
//
//  Created by gnksbm on 4/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

public extension UIViewController {
    func presentImg(img: UIImage?) {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let imgView = UIImageView()
        imgView.image = img
        imgView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(imgView)
        let safeArea = vc.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
        present(
            vc,
            animated: true
        )
    }
}
