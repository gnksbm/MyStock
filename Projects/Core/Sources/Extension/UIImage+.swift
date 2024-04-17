//
//  UIImage+.swift
//  Core
//
//  Created by gnksbm on 4/10/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import UIKit
import CoreImage.CIFilterBuiltins

public extension UIImage {
    static func generateQRImg(data: Data) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let transform = CGAffineTransform(
            scaleX: 5,
            y: 5
        )
        filter.setValue(
            data,
            forKey: "inputMessage"
        )
        guard let ciImg = filter.outputImage
        else { return nil }
        let scaledImg = ciImg.transformed(by: transform)
        guard let cgImg = context.createCGImage(
            scaledImg,
            from: scaledImg.extent
        )
        else { return nil }
        return UIImage(cgImage: cgImg)
    }
}
