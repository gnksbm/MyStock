//
//  Dependency+ThirdPartyExternal.swift
//  DependencyPlugin
//
//  Created by gnksbm on 2023/12/27.
//

import ProjectDescription

public extension Array<TargetDependency> {
    enum ThirdPartyExternal: CaseIterable {
        case rxCocoa, cryptoSwift, xmlCoder
        
        public var name: String {
            switch self {
            case .rxCocoa:
                return "RxCocoa"
            case .cryptoSwift:
                return "CryptoSwift"
            case .xmlCoder:
                return "XMLCoder"
            }
        }
    }
}
