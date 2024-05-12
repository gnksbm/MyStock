//
//  SearchStockViewController.swift
//  SearchFeature
//
//  Created by gnksbm on 1/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency
import DesignSystem
import Domain

import RxSwift
import RxCocoa
import SnapKit

final class SearchStockViewController: BaseViewController {
    private let viewModel: SearchStockViewModel
    private var dataSource: DataSource!
    
    private let stockCellTapEvent = PublishSubject<SearchStocksResponse>()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "종목명, 종목코드를 입력하세요."
        return textField
    }()
    
    private let searchStocksTableView = StockInfoTableView()
    
    init(viewModel: SearchStockViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        configureTableView()
        bind()
        hideKeyboardOnTapAndOrDrag()
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
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                searchTerm: searchTextField.rx
                    .text
                    .orEmpty
                    .skip(1)
                    .asObservable(),
                stockCellTapEvent: stockCellTapEvent
            )
        )
        
        output.searchResult
            .bindSnapshot(to: updateSnapshot)
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(UIViewController.viewDidAppear))
            .withUnretained(self)
            .take(1)
            .subscribe(
                onNext: { viewController, _ in
                    viewController.searchTextField.becomeFirstResponder()
                }
            )
            .disposed(by: disposeBag)
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
    
    private func configureTableView() {
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
