import XCTest

import RxSwift

@testable import Networks

final class NetworksTests: XCTestCase {
    var sut: NetworkService!
    var endPoint: KISOAuthEndPoint!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        sut = DefaultNetworkService()
        endPoint = .init(investType: .simulation)
        disposeBag = .init()
    }

    override func tearDownWithError() throws {
    }

    func test_KISOAuthEndPoint() throws {
        sut.send(endPoint: endPoint)
            .subscribe { _ in
                print("Success")
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }.disposed(by: disposeBag)
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }
}
