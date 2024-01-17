//
//  SearchStocksViewController.swift
//  HomeFeature
//
//  Created by gnksbm on 1/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency

final class SearchStocksViewController: BaseViewController {
    private let viewModel: SearchStocksViewModel
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "종목명, 종목코드를 입력하세요."
        return textField
    }()
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
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
    }
    
    private func configureUI() { 
        [searchTextField, resultTableView].forEach {
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
            
            resultTableView.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor
            ),
            resultTableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            resultTableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            resultTableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
}
