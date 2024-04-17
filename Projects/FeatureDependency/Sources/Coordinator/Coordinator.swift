//
//  Coordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 2023/11/25.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit

public protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }
    var childs: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
    func finish()
}

public extension Coordinator {
    func finish() {
        parent?.childDidFinish(self)
    }
    
    func startChildCoordinator(_ child: Coordinator) {
        childs.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator) {
        childs = childs.filter { $0 !== child }
    }
    
    func presentWithImg(img: UIImage?) {
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
        navigationController.present(
            vc,
            animated: true
        )
    }
    
    func showAlert(
        title: String,
        message: String,
        alertAction : [UIAlertAction] = [
            UIAlertAction(
                title: "확인",
                style: .default
            )
        ]
    ) {
        let alertVC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertAction.forEach { alertAction in
            alertVC.addAction(alertAction)
        }
        navigationController.present(
            alertVC,
            animated: true
        )
    }
}
