//
//  DefaultSearchStocksRepository.swift
//  Data
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core
import Domain

import RxSwift

public final class DefaultSearchStocksRepository: SearchStocksRepository {
    private var stocks = [SearchStocksResponse]()
    
    public init() {
        fetchTickers()
    }
    
    public func searchStocks(
        searchTerm: String
    ) -> Observable<[SearchStocksResponse]> {
        Observable.create { observer in
            observer.onNext(
                self.stocks.filter {
                    $0.name.lowercased().contains(searchTerm.lowercased()) ||
                    $0.ticker.lowercased().contains(searchTerm.lowercased())
                }
            )
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func fetchTickers() {
        do {
            let kospiResponse = try fetchKospi()
            let kosdaqResponse = try fetchKosdaq()
            let nasdaqResponse = try fetchNasdaq()
            stocks = kospiResponse + kosdaqResponse + nasdaqResponse
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchKospi() throws -> [SearchStocksResponse] {
        do {
            let kospiArr = try CSVManager.getTickerList(asset: .kospi)
            let resultTickers: [SearchStocksResponse] = kospiArr.map {
                let ticker = $0[0].dropFirst(3).dropLast(3)
                let name = $0[3]
                return .init(
                    ticker: String(ticker), name: name, marketType: .domestic)
            }
            return resultTickers
        } catch {
            throw error
        }
    }
    
    private func fetchKosdaq() throws -> [SearchStocksResponse] {
        do {
            let kosdaqArr = try CSVManager.getTickerList(asset: .kosdaq)
            let resultTickers: [SearchStocksResponse] = kosdaqArr.map {
                let ticker = $0[0].dropFirst(3).dropLast(3)
                let name = $0[3]
                return .init(
                    ticker: String(ticker), name: name, marketType: .domestic)
            }
            return resultTickers
        } catch {
            throw error
        }
    }
    
    private func fetchNasdaq() throws -> [SearchStocksResponse] {
        do {
            let nasdaqArr = try CSVManager.getTickerList(asset: .nasdaq)
            let resultTickers: [SearchStocksResponse] = nasdaqArr.map {
                let ticker = $0[0]
                let name = $0[1]
                return .init(
                    ticker: ticker, name: name, marketType: .overseas)
            }
            return resultTickers
        } catch {
            throw error
        }
    }
}
