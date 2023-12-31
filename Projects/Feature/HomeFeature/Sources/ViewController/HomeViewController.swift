import UIKit

import Networks
import FeatureDependency

import RxSwift
import RxCocoa

public final class HomeViewController: BaseViewController, UIScrollViewDelegate {
    private let viewModel: HomeViewModel
    
    lazy var collectionView: UICollectionView = {
        let layout = makeLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            HomeStockCVCell.self,
            forCellWithReuseIdentifier: HomeStockCVCell.identifier
        )
        return collectionView
    }()
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: safeArea.topAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor
            ),
        ])
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: .init(
                viewWillAppear: self.rx.methodInvoked(
                    #selector(UIViewController.viewWillAppear)
                ).map { _ in }
            )
        )
        
        output.balanceInfoList
            .bind(
                to: collectionView.rx.items(
                    cellIdentifier: HomeStockCVCell.identifier,
                    cellType: HomeStockCVCell.self
                ),
                curriedArgument: { _, item, cell in
                    cell.prepare(item: item)
                }
            )
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        .init { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalWidth(1/2)
                )
            )
            item.contentInsets = .init(
                top: 10,
                leading: 10,
                bottom: 10,
                trailing: 10
            )
            let hGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1/2)
                ),
                subitems: [item]
            )
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                ),
                subitems: [hGroup]
            )
            let section = NSCollectionLayoutSection(group: vGroup)
            return section
        }
    }
}

#if DEBUG
import SwiftUI
import FeatureDependency
struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIKitPreview(
            HomeViewController(
                viewModel: HomeViewModel()
            )
        )
    }
}
#endif

extension HomeViewController: URLSessionWebSocketDelegate {
    func testWS() {
        let aprovalKey = "faa648e9-ceee-4554-b134-595fc3e4269b"
        let endPoint = KISRealTimePriceEndPoint(
            approvalKey: aprovalKey,
            ticker: "DNASAAPL",
            investType: .reality,
            marketType: .overseas
        )
        WebSocket.shared.urlRequest = endPoint.toURLRequest
        do {
            try WebSocket.shared.openWebSocket()
        } catch {
            print(error.localizedDescription)
        }
        WebSocket.shared.delegate = self
        WebSocket.shared.receive { string, data in
            print("Receive")
            if let string {
                print(string)
                do {
                    guard let data = string.data(using: .utf8) else { return }
                    let response = try JSONDecoder().decode(
                        Response.self,
                        from: data
                    )
                    _ = response.body.output.iv
                    _ = response.body.output.key
                } catch {
                    print(error.localizedDescription)
                }
            } else if let data {
                print(data.description)
            }
        }
    }
    
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        print("open with \(`protocol` ?? "NoProtocol")")
        let aprovalKey = "faa648e9-ceee-4554-b134-595fc3e4269b"
        let endPoint = KISRealTimePriceEndPoint(
            approvalKey: aprovalKey,
            ticker: "DNASAAPL",
            investType: .reality,
            marketType: .overseas
        )
        guard let data = endPoint.requestJson else {
            print("\nBad Request\n")
            return
        }
        WebSocket.shared.send(data: data)
    }
    
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        guard let reason = reason else {
            print("No reason provided for WebSocket closure")
            return
        }
        print("Error", reason)
        print("close")
    }
}

enum WebSocketError: Error {
    case invalidURL
}

final class WebSocket: NSObject {
    static let shared = WebSocket()
    
    var urlRequest: URLRequest?
    var onReceiveClosure: ((String?, Data?) -> Void)?
    weak var delegate: URLSessionWebSocketDelegate?
    
    private var webSocketTask: URLSessionWebSocketTask? {
        didSet { oldValue?.cancel(with: .goingAway, reason: nil) }
    }
    private var timer: Timer?
    
    private override init() {}
    
    func openWebSocket() throws {
        guard let urlRequest else { throw WebSocketError.invalidURL }
        
        let urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        let webSocketTask = urlSession.webSocketTask(with: urlRequest)
        webSocketTask.resume()
        self.webSocketTask = webSocketTask
        self.startPing()
    }
    
    func send(message: String) {
        self.send(message: message, data: nil)
    }
    
    func send(data: Data) {
        self.send(message: nil, data: data)
    }
    
    private func send(message: String?, data: Data?) {
        let taskMessage: URLSessionWebSocketTask.Message
        if let string = message {
            taskMessage = URLSessionWebSocketTask.Message.string(string)
        } else if let data = data {
            taskMessage = URLSessionWebSocketTask.Message.data(data)
        } else {
            return
        }
        print("Send message \(taskMessage)")
        self.webSocketTask?.send(taskMessage, completionHandler: { error in
            guard let error else { return }
            print("WebSOcket sending error: \(error)")
        })
    }
    
    func closeWebSocket() {
        self.webSocketTask = nil
        self.timer?.invalidate()
        self.onReceiveClosure = nil
        self.delegate = nil
    }
    
    func receive(onReceive: @escaping (String?, Data?) -> Void) {
        self.onReceiveClosure = onReceive
        self.webSocketTask?.receive(completionHandler: { result in
            switch result {
            case let .success(message):
                switch message {
                case let .string(string):
                    onReceive(string, nil)
                case let .data(data):
                    onReceive(nil, data)
                @unknown default:
                    onReceive(nil, nil)
                }
            case let .failure(error):
                print("Received error \(error)")
            }
        })
    }
    
    private func startPing() {
        print("startPing")
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 10,
            repeats: true,
            block: { [weak self] _ in
                self?.ping()
            }
        )
    }
    
    private func ping() {
        print("ping")
        self.webSocketTask?.sendPing(pongReceiveHandler: { [weak self] error in
            guard let error = error else { return }
            print("Ping failed \(error)")
            print("pingReceive")
            self?.startPing()
        })
    }
}

extension WebSocket: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        self.delegate?.urlSession?(
            session,
            webSocketTask: webSocketTask,
            didOpenWithProtocol: `protocol`
        )
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        self.delegate?.urlSession?(
            session,
            webSocketTask: webSocketTask,
            didCloseWith: closeCode,
            reason: reason
        )
    }
}
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let rtCD, msgCD, msg1: String
    let output: Output
    
    enum CodingKeys: String, CodingKey {
        case rtCD = "rt_cd"
        case msgCD = "msg_cd"
        case msg1, output
    }
}

// MARK: - Output
struct Output: Codable {
    let iv, key: String
}

// MARK: - Header
struct Header: Codable {
    let trID, trKey, encrypt: String
    
    enum CodingKeys: String, CodingKey {
        case trID = "tr_id"
        case trKey = "tr_key"
        case encrypt
    }
}
