//
//  ViewModel.swift
//  FeatureDependency
//
//  Created by gnksbm on 2023/11/25.
//  Copyright © 2023 https://github.com/gnksbm/Clone_AppStore. All rights reserved.
//

import Foundation

public protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
