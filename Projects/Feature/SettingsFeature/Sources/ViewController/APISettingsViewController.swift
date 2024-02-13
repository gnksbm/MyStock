//
//  APISettingsViewController.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/13/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class APISettingsViewController: UIViewController {
    private let viewModel = APISettingsViewModel()
    
    private let appKeyTextField = KISTextFieldView(title: "앱키")
    private let secretKeyTextField = KISTextFieldView(title: "시크릿키")
    private let saveBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(ofSize: 20, weight: .regular)
        titleContainer.foregroundColor = .white
        config.attributedTitle = AttributedString(
            "저장",
            attributes: titleContainer
        )
        let button = UIButton(configuration: config)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
    }
    
    private func configureUI() {
        [appKeyTextField, secretKeyTextField].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            appKeyTextField.bottomAnchor.constraint(
                equalTo: safeArea.centerYAnchor,
                constant: -5
            ),
            appKeyTextField.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            appKeyTextField.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            
            secretKeyTextField.topAnchor.constraint(
                equalTo: safeArea.centerYAnchor,
                constant: 5
            ),
            secretKeyTextField.widthAnchor.constraint(
                equalTo: safeArea.widthAnchor,
                multiplier: 0.8
            ),
            secretKeyTextField.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
        ])
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = .init(customView: saveBtn)
    }
    
    private func bind() {
        viewModel.transform(
            input: .init(
                appKeyText: appKeyTextField.text,
                secretKeyText: secretKeyTextField.text,
                saveBtnTapEvent: saveBtn.rx.tap.asObservable()
            )
        )
    }
}
