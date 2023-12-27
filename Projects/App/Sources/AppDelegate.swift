//
//  AppDelegate.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/15.
//  Copyright © 2023 gnksbm All rights reserved.
//

import UIKit
import Networks
import Domain
import Data

import RxSwift

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        registerDependencies()
        test()
        return true
    }
    
    let networkService = DefaultNetworkService()
    let oAuth = PublishSubject<String>()
    let disposeBag = DisposeBag()
    lazy var oAuthRepository = DefaultKISOAuthRepository(networkService: networkService)
    lazy var balanceRepository = DefaultKISCheckBalanceRepository(networkService: networkService)
    
    func test() {
        oAuthRepository.requestOAuth(
            request: .init(
                oAuthType: .access,
                investType: .reality
            )
        )
        oAuthRepository.successedFetch
            .withUnretained(self)
            .bind { appDelegate, token in
                appDelegate.oAuth.onNext(token)
            }
            .disposed(by: disposeBag)
        oAuth.withUnretained(self)
            .subscribe(
                onNext: { appDelegate, token in
                    appDelegate.balanceRepository.requestBalance(
                        request: .init(
                            investType: .reality,
                            accountRequest: .init(accountNumber: "80847287")
                        ),
                        authorization: token
                    )
                },
                onError: { print($0.localizedDescription) }
            ).disposed(by: disposeBag)
        balanceRepository.successedFetch
            .subscribe(
                onNext: { print($0) },
                onError: { print($0.localizedDescription) }
            )
            .disposed(by: disposeBag)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
