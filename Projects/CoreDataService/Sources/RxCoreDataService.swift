//
//  RxCoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 5/4/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

import RxSwift

public protocol RxCoreDataService {
    func fetch<T: CoreDataStorable>(
        type: T.Type
    ) -> Observable<[T]>
    func saveUniqueData<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) -> Observable<T>
    func update<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) -> Observable<T>
    func delete<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) -> Observable<T>
}
