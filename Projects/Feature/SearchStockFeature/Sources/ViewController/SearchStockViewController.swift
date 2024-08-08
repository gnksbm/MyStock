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
import ThirdPartyLibs

import ReactorKit
import RxCocoa
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
    
    private let searchCollectionView = SearchCollectionView()
    
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
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, items in
                vc.searchCollectionView.applyItem(items: items)
            }
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
