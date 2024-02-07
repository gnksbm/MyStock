//
//  FavoritesFooterView.swift
//  FavoritesFeature
//
//  Created by gnksbm on 1/28/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift
import RxCocoa

final class FavoritesFooterView: UITableViewHeaderFooterView {
    private let disposeBag = DisposeBag()
    
    private let addBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let font = UIFont.boldSystemFont(ofSize: 20)
        let image = UIImage(systemName: "plus.circle")
        let imgConfig = UIImage.SymbolConfiguration(
            font: font
        )
        var titleContainer = AttributeContainer()
        titleContainer.font = font
        titleContainer.foregroundColor = DesignSystemAsset.chartForeground.color
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        config.attributedTitle = AttributedString(
            "",
            attributes: titleContainer
        )
        let button = UIButton(configuration: config)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [addBtn].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            addBtn.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
//            addBtn.leadingAnchor.constraint(
//                equalTo: contentView.leadingAnchor
//            ),
            addBtn.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            addBtn.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
        ])
    }
}
