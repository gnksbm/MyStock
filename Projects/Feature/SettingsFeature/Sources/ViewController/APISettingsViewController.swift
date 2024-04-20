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
import FeatureDependency

import RxSwift
import RxCocoa

final class APISettingsViewController: BaseViewController {
    private let viewModel: APISettingsViewModel
    
    let apiKeyCaptureEvent = PublishSubject<APIKey>()
    
    private let qrReaderBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(
            .init(systemName: "qrcode.viewfinder"),
            for: .normal
        )
        return btn
    }()
    
    private let qrGenerateBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(
            .init(systemName: "qrcode"),
            for: .normal
        )
        return btn
    }()
    
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
    
    private let appKeyTextField = KISTextFieldView(title: "앱키")
    private let secretKeyTextField = KISTextFieldView(title: "시크릿키")
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
        navigationItem.setRightBarButtonItems(
            [
                .init(customView: saveBtn),
                .init(customView: qrGenerateBtn),
                .init(customView: qrReaderBtn),
            ],
            animated: false
        )
    }
    
    private func bind() {
        let appKeyTextEvent = appKeyTextField.textField.rx
            .text
            .asObservable()
        let secretKeyTextEvent = secretKeyTextField.textField.rx
            .text
            .asObservable()
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: rx.methodInvoked(
                    #selector(UIViewController.viewWillAppear)
                ).map { _ in },
                qrReaderBtnEvent: qrReaderBtn.rx.tap.asObservable(),
                qrGenerateBtnEvent: qrGenerateBtn.rx.tap
                    .flatMap { _ in
                        Observable.combineLatest(
                            appKeyTextEvent,
                            secretKeyTextEvent
                        )
                    }
                    .map { tuple in
                        let (appKey, secretKey) = tuple
                        return .init(
                            appKey: appKey ?? "값 없음",
                            secretKey: secretKey ?? "값 없음"
                        )
                    },
                saveBtnTapEvent: saveBtn.rx.tap
                    .flatMap { _ in
                        Observable.combineLatest(
                            appKeyTextEvent,
                            secretKeyTextEvent
                        )
                    }
                    .map { tuple in
                        let (appKey, secretKey) = tuple
                        return .init(
                            appKey: appKey ?? "값 없음",
                            secretKey: secretKey ?? "값 없음"
                        )
                    }
            )
        )
        
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

struct APIKey: Codable {
    let appKey: String
    let secretKey: String
}
