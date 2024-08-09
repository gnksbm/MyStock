import Foundation

public protocol SummaryCoordinator: Coordinator { 
    func startDetailFlow(ticker: String)
}
