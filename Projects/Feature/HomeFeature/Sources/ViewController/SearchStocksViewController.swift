//
//  SearchStocksViewController.swift
//  HomeFeature
//
//  Created by gnksbm on 1/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency

import RxSwift
import RxCocoa

final class SearchStocksViewController: BaseViewController {
    private let viewModel: SearchStocksViewModel
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "종목명, 종목코드를 입력하세요."
        return textField
    }()
    
    private let searchStocksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SearchStocksTVCell.self,
            forCellReuseIdentifier: SearchStocksTVCell.identifier
        )
        return tableView
    }()
    
    init(viewModel: SearchStocksViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
    }
    
    private func bind() { 
        let output = viewModel.transform(
            input: .init(
                searchTerm: searchTextField.rx
                    .text
                    .orEmpty
                    .asObservable()
            )
        )
        output.searchResult
            .bind(
                to: searchStocksTableView.rx.items(
                    cellIdentifier: SearchStocksTVCell.identifier,
                    cellType: SearchStocksTVCell.self
                ),
                curriedArgument: { _, response, cell in
                    cell.prepare(response: response)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func configureUI() { 
        [searchTextField, searchStocksTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchTextField.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: 10
            ),
            searchTextField.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -10
            ),
            
            searchStocksTableView.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor
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
}
