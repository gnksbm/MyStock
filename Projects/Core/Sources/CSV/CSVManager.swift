//
//  CSVManager.swift
//  Core
//
//  Created by gnksbm on 1/17/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public enum CSVError: LocalizedError {
    case invalidURL(String)
    case invalidData
    case parseError
    
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        case .invalidURL(let fileName):
            return "\(fileName): 유효하지 않은 URL입니다."
        case .parseError:
            return "데이터 파싱에 실패하였습니다."
        }
    }
}

public final class CSVManager {
    public static func getTickerList(asset: CSVAsset) throws -> [[String]] {
        do {
            let data = try fetchData(asset: asset)
            guard let str = String(data: data, encoding: .utf8)
            else { throw CSVError.parseError }
            var resultArr = str.components(separatedBy: "\n")
            resultArr.removeFirst()
            return resultArr.map { $0.components(separatedBy: ",") }
        } catch {
            throw error
        }
    }
    public static func fetchData(asset: CSVAsset) throws -> Data {
        guard let url = Bundle.main.url(
            forResource: asset.fileName,
            withExtension: "csv"
        )
        else { throw CSVError.invalidURL(asset.fileName) }
        do {
            return try Data(contentsOf: url)
        } catch {
            throw CSVError.invalidData
        }
    }
    
    public enum CSVAsset {
        case kospi, kosdaq, nasdaq
        
        fileprivate var fileName: String {
            switch self {
            case .kospi:
                return "kospi_20240117"
            case .kosdaq:
                return "kosdaq_20240120"
            case .nasdaq:
                return "nasdaq_20240118"
            }
        }
    }
}
