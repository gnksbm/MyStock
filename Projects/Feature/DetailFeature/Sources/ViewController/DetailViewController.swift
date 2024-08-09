import UIKit

import Core
import DesignSystem

import RxSwift
import RxCocoa

public final class DetailViewController: BaseViewController<DetailReactor> {
    private let logoImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = DesignSystemAsset.Radius.logoImage
        return imageView
    }()
    private let nameLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        return label
    }()
    private let priceLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let rateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private let dateLabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = .systemFont(ofSize: 13)
        label.textColor = DesignSystemAsset.accentColor.color
        return label
    }()
    private let openingPriceView = DescriptionView(
        title: "시가",
        titleColor: DesignSystemAsset.whiteCandle.color
    )
    private let volumeView = DescriptionView(
        title: "거래량",
        titleColor: DesignSystemAsset.blackCandle.color
    )
    private let highPriceView = DescriptionView(
        title: "고가",
        titleColor: DesignSystemAsset.whiteCandle.color
    )
    private let lowPriceView = DescriptionView(
        title: "저가",
        titleColor: DesignSystemAsset.blackCandle.color
    )
    private lazy var stackView = UIStackView(
        spacing: DesignSystemAsset.Padding.regular,
        axis: .vertical,
        distribution: .equalSpacing
    ) { 
        UIStackView(distribution: .fillEqually) {
            openingPriceView
            volumeView
        }
        UIStackView(distribution: .fillEqually) {
            highPriceView
            lowPriceView
        }
    }
    
    public override func bindState(reactor: DetailReactor) {
        let state = reactor.state.share()
        
        disposeBag.insert {
            state.compactMap { $0.dailyPriceInfo }
                .bind(with: self) { vc, item in
                    vc.logoImageView.image = item.image
                    vc.nameLabel.text = item.name
                    vc.priceLabel.text = item.price
                    vc.rateLabel.textColor =
                    item.fluctuationRate.toForegroundColorForNumeric
                    vc.openingPriceView.updateValue(item.openingPrice)
                    vc.volumeView.updateValue(item.volume)
                    vc.highPriceView.updateValue(item.highPrice)
                    vc.lowPriceView.updateValue(item.lowPrice)
                }
        }
    }
    
    public override func bindAction(reactor: DetailReactor) {
        disposeBag.insert {
            rx.methodInvoked(#selector(Self.viewDidLoad))
                .map { _ in DetailReactor.Action.viewWillAppearEvent }
                .bind(to: reactor.action)
        }
    }
    
    public override func configureLayout() {
        [
            logoImageView,
            nameLabel,
            priceLabel,
            rateLabel,
            dateLabel,
            stackView
        ].forEach { view.addSubview($0) }
        
        let padding = DesignSystemAsset.Padding.regular
        
        logoImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).inset(padding / 2)
            make.size.equalTo(DesignSystemAsset.Demension.logoImage)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.leading.equalTo(logoImageView.snp.trailing).offset(padding / 2)
            make.trailing.equalTo(safeArea).inset(padding / 2)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(padding)
            make.leading.equalTo(logoImageView)
            make.trailing.equalTo(nameLabel)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(padding / 2)
            make.leading.equalTo(logoImageView)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(rateLabel)
            make.leading.equalTo(rateLabel.snp.trailing)
            make.trailing.equalTo(nameLabel)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.bottom).offset(padding)
            make.leading.equalTo(logoImageView)
            make.trailing.equalTo(nameLabel)
        }
    }
}
