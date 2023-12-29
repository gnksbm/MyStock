//
//  SceneDelegate.swift
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

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appFlowCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        appFlowCoordinator = AppCoordinator(
            navigationController: navigationController
        )
        test()
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    let networkService = DefaultNetworkService()
    let oAuth = PublishSubject<String>()
    let disposeBag = DisposeBag()
    lazy var oAuthRepository = DefaultKISOAuthRepository(networkService: networkService)
    lazy var balanceRepository = DefaultKISCheckBalanceRepository(networkService: networkService)
    
    func test() {
        oAuth.withUnretained(self)
            .subscribe(
                onNext: { appDelegate, token in
                    appDelegate.balanceRepository.requestBalance(
                        request: .init(
                            investType: .reality,
                            marketType: .overseas,
                            accountNumber: "80847287"
                        ),
                        authorization: token
                    )
                },
                onError: { print($0.localizedDescription) }
            ).disposed(by: disposeBag)
        if let token = UserDefaults.standard.string(forKey: "token"),
           let data = UserDefaults.standard.data(forKey: "date"),
           let date = try? JSONDecoder().decode(Date.self, from: data),
           date.distance(to: .now) < 86400 {
            print("UserDefaultToken: \(date.distance(to: .now))")
            oAuth.onNext(token)
        } else {
            if let data = UserDefaults.standard.data(forKey: "date"),
               let date = try? JSONDecoder().decode(Date.self, from: data) {
                print("FetchToken: \(date.distance(to: .now))")
            }
            oAuthRepository.requestOAuth(
                request: .init(
                    oAuthType: .access,
                    investType: .reality
                )
            )
            oAuthRepository.token
                .withUnretained(self)
                .subscribe(
                    onNext: { appDelegate, token in
                        guard let data = try? JSONEncoder().encode(Date()) else { return }
                        UserDefaults.standard.setValue(token, forKey: "token")
                        UserDefaults.standard.setValue(data, forKey: "date")
                        appDelegate.oAuth.onNext(token)
                    },
                    onError: { print($0.localizedDescription) }
                )
                .disposed(by: disposeBag)
        }
        balanceRepository.successedFetch
            .withUnretained(self)
            .subscribe(
                onNext: { sceneDelegate, response in
//                    print(response.combineSameTiker)
//                    print(response.combineSameTiker.map { $0.value })
                    guard let price = response.map({ $0.price }).first
                    else { return }
                    sceneDelegate.appFlowCoordinator?.price.onNext(price)
                },
                onError: { print($0.localizedDescription) }
            )
            .disposed(by: disposeBag)
    }
}
