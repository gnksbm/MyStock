//
//  File.swift
//  Core
//
//  Created by gnksbm on 1/17/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public final class CSVParser {
    public static func fetchData(asset: CSVAsset) {
        guard let url = asset.url
        else { return }
        
        do {
            let data = try Data(contentsOf: url)
            print(data)
        } catch {
            print(error.localizedDescription)
        }

        do {
            let str = try String(contentsOf: url, encoding: .utf8)
            print(str)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public enum CSVAsset {
        case kospi, kosdaq
        
        var url: URL? {
            switch self {
            case .kospi:
                guard let urlStr = Bundle.main.path(
                    forResource: "kospi_20240117", ofType: "csv"
                )
                else { fatalError("kospi_20240117 Not Found") }
                return URL(string: urlStr)
            case .kosdaq:
                guard let urlStr = Bundle.main.path(
                    forResource: "kosdaq_20240117", ofType: "csv"
                )
                else { fatalError("kosdaq_20240117 Not Found") }
                return URL(string: urlStr)
            }
        }
    }
}
