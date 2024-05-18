import UIKit

import DesignSystem

import ReactorKit
import SnapKit

final class ChartViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
            make.edges.equalTo(safeArea)
        }
    }
    
    func bind(reactor: ChartReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ChartReactor) { 
        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in
                ChartReactor.Action.viewWillAppearEvent
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ChartReactor) {
        reactor.state
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(
                onNext: { vc, state in
                    vc.candleChartView.updateChart(
                        dataSource: state.candleDatas
                    )
                    if let closingPrice = state.candleDatas.last?
                        .closingPrice.removeDecimal {
                        vc.title = "\(state.title) \(closingPrice)"
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
