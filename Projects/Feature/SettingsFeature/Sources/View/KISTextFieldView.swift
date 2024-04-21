//
//  KISTextFieldView.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/13/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift
import RxCocoa

final class KISTextFieldView: UIView {
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    let textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textColor = .white
        return textField
    }()
    
    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = DesignSystemAsset.accentColor.color
        layer.cornerRadius = 10
        
        [textField, titleLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            
            textField.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10
            ),
            textField.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.9
            ),
            textField.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            textField.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            ),
        ])
    }
    
    private func bind() {
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .withUnretained(self)
            .subscribe(
                onNext: { view, _ in
                    view.textField.becomeFirstResponder()
                }
            )
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidBegin)
            .withUnretained(self)
            .subscribe(
                onNext: { view, _ in
                    let accentColor = DesignSystemAsset.accentColor.color
                    view.backgroundColor = .white
                    view.titleLabel.textColor = accentColor
                    view.textField.textColor = accentColor
                }
            )
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .subscribe(
                onNext: { view, _ in
                    let accentColor = DesignSystemAsset.accentColor.color
                    view.backgroundColor = accentColor
                    view.titleLabel.textColor = .white
                    view.textField.textColor = .white
                }
            )
            .disposed(by: disposeBag)
    }
}
