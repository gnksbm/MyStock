//
//  APISettingsViewController.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/13/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import Core
import Domain

import ReactorKit
import SnapKit

final class APISettingsViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
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
        hideKeyboardOnTap()
    }
    
    func bind(reactor: APISettingsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: APISettingsReactor) { 
        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .take(1)
            .map { _ in APISettingsReactor.Action.viewWillAppearEvent }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveBtn.rx.tap
            .withUnretained(self)
            .flatMap { vc, _ in
                Observable.combineLatest(
                    vc.accountNumTextField.textField.rx.text.orEmpty,
                    vc.appKeyTextField.textField.rx.text.orEmpty,
                    vc.secretKeyTextField.textField.rx.text.orEmpty
                )
            }
            .map { tuple in
                let (accountNum, appKey, secretKey) = tuple
                let userInfo = KISUserInfo(
                    accountNum: accountNum,
                    appKey: appKey,
                    secretKey: secretKey
                )
                return APISettingsReactor.Action.saveBtnTapEvent(
                    userInfo: userInfo
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: APISettingsReactor) { 
        reactor.state.map { $0.userInfo }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(
                onNext: { vc, userInfo in
                    vc.accountNumTextField.textField.rx.text.onNext(
                        userInfo.accountNum
                    )
                    vc.appKeyTextField.textField.rx.text.onNext(
                        userInfo.appKey
                    )
                    vc.secretKeyTextField.textField.rx.text.onNext(
                        userInfo.secretKey
                    )
                }
            )
            .disposed(by: disposeBag)
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
