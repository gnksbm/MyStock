//
//  QRCodeReaderViewController.swift
//  SettingsFeature
//
//  Created by gnksbm on 4/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import AVFoundation
import UIKit

import Core
import DesignSystem
import FeatureDependency

import RxSwift
import RxCocoa
import SnapKit

public final class QRCodeReaderViewController: BaseViewController {
    private let viewModel: QRCodeReaderViewModel
    weak var delegateVC: APISettingsViewController?
    
    private let capturedData = PublishSubject<Data>()
    
    private let captureSession = AVCaptureSession()
    
    private let cameraView = UIView()
    private let dismissBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let img = UIImage(systemName: "xmark")?
            .withConfiguration(
                UIImage.SymbolConfiguration.init(
                    font: .systemFont(ofSize: 20)
                )
            )
        config.image = img
        let btn = UIButton(configuration: config)
        btn.tintColor = DesignSystemAsset.chartForeground.color
        return btn
    }()
    
    init(viewModel: QRCodeReaderViewModel) {
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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCapture()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func configureUI() {
        view.backgroundColor = DesignSystemAsset.chartBackground.color
        [cameraView, dismissBtn].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        cameraView.snp.makeConstraints { make in
            make.width.equalTo(safeArea).multipliedBy(0.8)
            make.height.equalTo(cameraView.snp.width)
            make.centerX.centerY.equalTo(safeArea)
        }
        
        dismissBtn.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).offset(10)
        }
    }
    
    private func bind() {
        dismissBtn.rx.tap
            .withUnretained(self)
            .subscribe(
                onNext: { vc, _ in
                    vc.dismiss(animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        _ = viewModel.transform(
            input: .init(
                capturedData: capturedData
            )
        )
    }
    
    private func startCapture() {
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(
                    device: captureDevice
                )
                captureSession.addInput(input)
                let output = AVCaptureMetadataOutput()
                captureSession.addOutput(output)
                
                output.setMetadataObjectsDelegate(
                    self,
                    queue: DispatchQueue.main
                )
                output.metadataObjectTypes = [.qr]
                
                let previewLayer = AVCaptureVideoPreviewLayer(
                    session: captureSession
                )
                previewLayer.frame = cameraView.layer.bounds
                previewLayer.videoGravity = .resizeAspectFill
                cameraView.layer.addSublayer(previewLayer)
                
                DispatchQueue.global().async { [weak self] in
                    self?.captureSession.startRunning()
                }
            } catch {
                return
            }
        }
    }
}

extension QRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject
            as? AVMetadataMachineReadableCodeObject,
           let string = readableObject.stringValue {
            guard let data = string.data(using: .utf8)
            else { return }
            capturedData.onNext(data)
            dismiss(animated: true)
        }
    }
}
