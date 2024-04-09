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
    
    private let disposeBag = DisposeBag()
    
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
        bind()
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
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .withUnretained(self)
            .subscribe(
                onNext: { vc, _ in
                    vc.view.endEditing(true)
                }
            )
            .disposed(by: disposeBag)
        
        saveBtn.rx.tap
            .withUnretained(self)
            .subscribe(
                onNext: { vc, _ in
                    guard let appKeyIsEmpty = vc.appKeyTextField.textField
                        .text?.isEmpty,
                          let secretKeyIsEmpty = vc.secretKeyTextField.textField
                        .text?.isEmpty
                    else { return }
                    if appKeyIsEmpty || secretKeyIsEmpty {
                        var message = ""
                        if appKeyIsEmpty && secretKeyIsEmpty {
                            message = "앱키와 시크릿키를 입력해주세요"
                        } else if appKeyIsEmpty {
                            message = "앱키를 입력해주세요"
                        } else if secretKeyIsEmpty {
                            message = "시크릿키를 입력해주세요"
                        }
                        let alertVC = UIAlertController(
                            title: "잘못된 입력입니다",
                            message: message,
                            preferredStyle: .alert
                        )
                        let alertAction = UIAlertAction(
                            title: "확인",
                            style: .default
                        )
                        alertVC.addAction(alertAction)
                        vc.present(
                            alertVC,
                            animated: true
                        )
                    }
                }
            )
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx.methodInvoked(
                    #selector(UIViewController.viewWillAppear)
                ).map { _ in },
                appKeyText: appKeyTextField.textChangeEvent,
                secretKeyText: secretKeyTextField.textChangeEvent,
                saveBtnTapEvent: saveBtn.rx.tap
                    .withUnretained(self)
                    .filter { vc, _ in
                        guard let appKeyIsEmpty = vc.appKeyTextField.textField
                            .text?.isEmpty,
                              let secretKeyIsEmpty = vc.secretKeyTextField
                            .textField.text?.isEmpty
                        else { return false }
                        return !appKeyIsEmpty && !secretKeyIsEmpty
                    }
                    .map { _ in }
            )
        )
        
        output.appKey
            .bind(to: appKeyTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.secretKey
            .bind(to: secretKeyTextField.textField.rx.text)
            .disposed(by: disposeBag)
    }
}
