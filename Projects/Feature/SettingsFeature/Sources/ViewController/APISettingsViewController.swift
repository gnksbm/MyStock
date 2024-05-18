//
//  APISettingsViewController.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/13/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

import Core
import Domain
import FeatureDependency

import RxSwift
import RxCocoa
import SnapKit

final class APISettingsViewController: BaseViewController {
    private let viewModel: APISettingsViewModel
    
    let apiKeyCaptureEvent = PublishSubject<KISUserInfo>()
    
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
    
    private let accountNumTextField = KISTextFieldView(title: "계좌번호")
    private let appKeyTextField = KISTextFieldView(title: "앱키")
    private let secretKeyTextField = KISTextFieldView(title: "시크릿키")
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                accountNumTextField,
                appKeyTextField,
                secretKeyTextField,
            ]
        )
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        bind()
    }
    
    init(viewModel: APISettingsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [stackView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.8)
        }
    }
    
    private func configureNavigation() {
        navigationItem.setRightBarButtonItems(
            [
                .init(customView: saveBtn),
            ],
            animated: false
        )
    }
    
    private func bind() {
        let accountNumTextEvent = accountNumTextField.textField.rx.text
            .orEmpty
            .asObservable()
        let appKeyTextEvent = appKeyTextField.textField.rx.text
            .orEmpty
            .asObservable()
        let secretKeyTextEvent = secretKeyTextField.textField.rx.text
            .orEmpty
            .asObservable()
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx.methodInvoked(
                    #selector(UIViewController.viewWillAppear)
                ).map { _ in },
                saveBtnTapEvent: saveBtn.rx.tap
                    .flatMap { _ in
                        Observable.combineLatest(
                            accountNumTextEvent,
                            appKeyTextEvent,
                            secretKeyTextEvent
                        )
                    }
                    .map { tuple in
                        let (accountNum, appKey, secretKey) = tuple
                        return .init(
                            accountNum: accountNum,
                            appKey: appKey,
                            secretKey: secretKey
                        )
                    }
            )
        )
        
        output.accountNum
            .bind(to: accountNumTextField.textField.rx.text)
            .disposed(by: disposeBag)
        output.appKey
            .bind(to: appKeyTextField.textField.rx.text)
            .disposed(by: disposeBag)
        output.secretKey
            .bind(to: secretKeyTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
        apiKeyCaptureEvent
            .withUnretained(self)
            .subscribe(
                onNext: { vc, apiKey in
                    vc.accountNumTextField.textField.rx
                        .text
                        .onNext(apiKey.accountNum)
                    vc.appKeyTextField.textField.rx
                        .text
                        .onNext(apiKey.appKey)
                    vc.secretKeyTextField.textField.rx
                        .text
                        .onNext(apiKey.secretKey)
                }
            )
            .disposed(by: disposeBag)
        
        hideKeyboardOnTap()
    }
    
    private func hideKeyboardOnTap() {
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
    }
}
