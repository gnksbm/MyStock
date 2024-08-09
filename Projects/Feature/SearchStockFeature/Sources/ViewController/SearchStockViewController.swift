//
//  SearchStockViewController.swift
//  SearchFeature
//
//  Created by gnksbm on 1/16/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain
import FeatureDependency
import ThirdPartyLibs

import ReactorKit
import RxCocoa
import SnapKit

final class SearchStockViewController: BaseViewController<SearchStockReactor> {
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "종목명, 종목코드를 입력하세요."
        return textField
    }()
    
    private let searchCollectionView = SearchCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        hideKeyboardOnTapAndOrDrag()
    }
    
    override func bindAction(reactor: SearchStockReactor) {
        disposeBag.insert {
            searchTextField.rx.controlEvent(.editingDidEndOnExit)
                .withLatestFrom(searchTextField.rx.text.orEmpty) { $1 }
                .asObservable()
                .map {
                    SearchStockReactor.Action
                        .searchTermChangeEvent(searchTerm: $0)
                }
                .bind(to: reactor.action)
            
            searchCollectionView.cellTapEvent
                .map { SearchStockReactor.Action.stockCellTapEvent($0) }
                .bind(to: reactor.action)
            
            searchCollectionView.likeButtonTapEvent
                .map { SearchStockReactor.Action.likeButtonTapEvent($0) }
                .bind(to: reactor.action)
        }
    }
    
    override func bindState(reactor: SearchStockReactor) {
        let state = reactor.state
        disposeBag.insert {
            state.map { $0.searchResult }
                .observe(on: MainScheduler.instance)
                .withUnretained(self)
                .bind { vc, items in
                    vc.searchCollectionView.applyItem(items: items)
                }
            
            state.map { $0.isSearching }
                .observe(on: MainScheduler.asyncInstance)
                .withUnretained(self)
                .subscribe(
                    onNext: { _, _ in
                        // TODO: Loading 화면 노출
                    }
                )
        }
    }
    
    override func configureLayout() {
        [searchTextField, searchCollectionView].forEach {
            view.addSubview($0)
        }
        
        searchCollectionView.snp.equalToSafeArea(view)
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
        
        searchCollectionView.keyboardDismissMode = .onDrag
    }
}

extension SearchStockViewController {
    typealias DataSource
    = UITableViewDiffableDataSource<Int, SearchStocksResponse>
    typealias Snapshot
    = NSDiffableDataSourceSnapshot<Int, SearchStocksResponse>
}
