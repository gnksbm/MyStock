import UIKit
import Core
import FeatureDependency
import DesignSystem

import RxSwift
import RxCocoa
import SnapKit

final class ChartViewController: BaseViewController {
    private var viewModel: ChartViewModel
    
    private let searchBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "magnifyingglass")
        let imgConfig = UIImage.SymbolConfiguration(
            font: .boldSystemFont(ofSize: 20)
        )
        config.image = image
        config.preferredSymbolConfigurationForImage = imgConfig
        let button = UIButton(configuration: config)
        return button
    }()
    
    private lazy var candleChartView: CandlestickChartView = {
        let candleChartView = CandlestickChartView()
        candleChartView.appearance = .init(
            whiteCandleColor: DesignSystemAsset.whiteCandle.color,
            blackCandleColor: DesignSystemAsset.blackCandle.color,
            backgroundColor: DesignSystemAsset.chartBackground.color
        )
        return candleChartView
    }()
    
    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
        bind()
    }
    
    private func configureUI() {
        let foregrondColor = DesignSystemAsset.chartForeground.color
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: foregrondColor
        ]

        [candleChartView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        candleChartView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                viewWillAppearEvent: self.rx.methodInvoked(
                    #selector(UIViewController.viewWillAppear)
                ).map { _ in }
            )
        )
        
        output.candleDatas
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: { vc, responses in
                    vc.candleChartView.updateChart(dataSource: responses)
                    if let candleData = responses.last {
                        let closingPrice = candleData.closingPrice.removeDecimal
                        vc.title = "\(output.title) \(closingPrice)"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
