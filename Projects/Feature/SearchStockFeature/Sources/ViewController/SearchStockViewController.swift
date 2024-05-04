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

import RxSwift
import RxCocoa

final class SearchStockViewController: BaseViewController {
    private let viewModel: SearchStockViewModel
    
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
        bind()
        configureNavigation()
        hideKeyboardOnTapAndOrDrag()
    }
    
    private func configureUI() {
        [searchTextField, searchStocksTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchStocksTableView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            searchStocksTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            searchStocksTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            searchStocksTableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                searchTerm: searchTextField.rx
                    .text
                    .orEmpty
                    .asObservable(),
                stockCellTapEvent: searchStocksTableView.rx
                    .itemSelected
                    .map { $0.row }
            )
        )
        
        output.searchResult
            .bind(
                to: searchStocksTableView.rx.items(
                    cellIdentifier: StockInfoTVCell.identifier,
                    cellType: StockInfoTVCell.self
                ),
                curriedArgument: { _, response, cell in
                    cell.updateUI(
                        ticker: response.ticker,
                        name: response.name
                    )
                }
            )
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
}
