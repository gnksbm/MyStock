//
//  SettingsButton.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/21/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import DesignSystem

final class SettingsButton: UIButton {
    private let imgConfig = UIImage.SymbolConfiguration.init(
        font: .boldSystemFont(ofSize: 20)
    )
    
    private lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.tintColor = DesignSystemAsset.chartForeground.color
        imgView.preferredSymbolConfiguration = imgConfig
        return imgView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 20,
            weight: .semibold
        )
        return label
    }()
    
    private lazy var navigationImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "chevron.right")
        imgView.tintColor = DesignSystemAsset.chartForeground.color
        imgView.preferredSymbolConfiguration = imgConfig
        return imgView
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystemAsset.chartForeground.color
        return view
    }()
    
    init(
        title: String?,
        icon: UIImage?,
        isNavigationBtn: Bool
    ) {
        super.init(frame: .zero)
        descriptionLabel.text = title
        iconImgView.image = icon
        navigationImgView.isHidden = !isNavigationBtn
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [
            iconImgView,
            descriptionLabel, 
            navigationImgView,
            underLineView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            iconImgView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            iconImgView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            iconImgView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -20
            ),
            
            descriptionLabel.leadingAnchor.constraint(
                equalTo: iconImgView.trailingAnchor,
                constant: 20
            ),
            descriptionLabel.centerYAnchor.constraint(
                equalTo: iconImgView.centerYAnchor
            ),
            
            navigationImgView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            navigationImgView.centerYAnchor.constraint(
                equalTo: iconImgView.centerYAnchor
            ),
            
            underLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            underLineView.heightAnchor.constraint(equalToConstant: 1),
            underLineView.widthAnchor.constraint(
                equalTo: widthAnchor,
                constant: -20
            ),
        ])
    }
}
