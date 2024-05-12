//
//  SettingsButton.swift
//  SettingsFeature
//
//  Created by gnksbm on 2/21/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import DesignSystem

import SnapKit

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
        label.textColor = DesignSystemAsset.chartForeground.color
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
        }
        
        iconImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImgView)
            make.leading.equalTo(iconImgView.snp.trailing).offset(20)
        }
        
        navigationImgView.snp.makeConstraints { make in
            make.centerY.equalTo(iconImgView)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        underLineView.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().offset(-20)
        }
    }
}
