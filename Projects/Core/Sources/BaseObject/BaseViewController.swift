//
//  BaseViewController.swift
//  Core
//
//  Created by gnksbm on 8/7/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

open class BaseViewController
<ReactorType: Reactor>: UIViewController, View {
    public var disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
        configureLayout()
        configureDefailtUI()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final public func bind(reactor: ReactorType) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    open func bindAction(reactor: ReactorType) { }
    open func bindState(reactor: ReactorType) { }
    
    open func configureUI() { }
    open func configureLayout() { }
    
    private func configureDefailtUI() {
        view.backgroundColor = .white
    }
}
