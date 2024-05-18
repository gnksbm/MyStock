//
//  SearchStockViewController.swift
//  SearchFeature
//
//  Created by gnksbm on 1/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem
import Domain
import FeatureDependency

import ReactorKit
import SnapKit

final class SearchStockViewController: UIViewController, View {
    private var dataSource: DataSource!
    
    private let stockCellTapEvent = PublishSubject<SearchStocksResponse>()
    var disposeBag = DisposeBag()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "종목명, 종목코드를 입력하세요."
        return textField
    }()
    
    private let searchStocksTableView = StockInfoTableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        hideKeyboardOnTapAndOrDrag()
    }
    
    func bind(reactor: SearchStockReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SearchStockReactor) {
        searchTextField.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .debounce(
                .milliseconds(500),
                scheduler: MainScheduler.asyncInstance
            )
            .map {
                SearchStockReactor.Action.searchTermChangeEvent(searchTerm: $0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        stockCellTapEvent
            .map { SearchStockReactor.Action.stockCellTapEvent($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: SearchStockReactor) { 
        reactor.state.map { $0.searchResult }
            .bindSnapshot(to: updateSnapshot)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSearching }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(
                onNext: { _, _ in
                    // TODO: Loading 화면 노출
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        [searchTextField, searchStocksTableView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        searchStocksTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
    private func configureNavigation() {
        navigationItem.titleView = searchTextField
    }
    
    private func hideKeyboardOnTapAndOrDrag() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .withUnretained(self)
            .subscribe(
                onNext: { vc, _ in
                    vc.searchTextField.endEditing(true)
                }
            )
            .disposed(by: disposeBag)
        
        searchStocksTableView.keyboardDismissMode = .onDrag
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            tableView: searchStocksTableView
        ) { [weak self] tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StockInfoTVCell.identifier,
                for: indexPath
            ) as? StockInfoTVCell else { return .init() }
            cell.updateUI(
                image: item.image,
                ticker: item.ticker,
                name: item.name
            )
            let tapGesture = UITapGestureRecognizer()
            cell.addGestureRecognizer(tapGesture)
            tapGesture.rx.event
                .map { _ in item }
                .subscribe(
                    onNext: { response in
                        self?.stockCellTapEvent.onNext(response)
                    }
                )
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
    
    private func updateSnapshot(items: [SearchStocksResponse]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(
            snapshot,
            animatingDifferences: false
        )
    }
}

extension SearchStockViewController {
    typealias DataSource
    = UITableViewDiffableDataSource<Int, SearchStocksResponse>
    typealias Snapshot
    = NSDiffableDataSourceSnapshot<Int, SearchStocksResponse>
}
