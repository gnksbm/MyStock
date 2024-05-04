//
//  DefaultRxCoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 5/4/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation
import CoreData

import Core

import RxSwift

public final class DefaultRxCoreDataService: RxCoreDataService {
    private let container: NSPersistentContainer
    
    public init() {
        container = NSPersistentContainer(name: "Model")
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentHistoryTrackingKey
        )
        container.loadPersistentStores { _, error in
            if let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    public func fetch<T: CoreDataStorable>(
        type: T.Type
    ) -> Observable<[T]> {
        fetchManagedObject(type: type)
            .compactMap { managedObjects in
                managedObjects as? [CoreDataModelObject]
            }
            .compactMap { abstract in
                abstract.compactMap { $0.toDomain as? T }
            }
    }
    
    public func saveUniqueData<T: CoreDataStorable, U>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) -> Observable<T> {
        fetchManagedObject(type: type(of: data))
            .flatMap { managedObjects in
                if managedObjects.contains(
                    where: { managedObject in
                        managedObject.value(
                            forKey: uniqueKeyPath.propertyName
                        ) != nil
                    }
                ) {
                    return Observable<T>.error(
                        CoreDataServiceError.notUnique
                    )
                } else {
                    return .just(data)
                }
            }
            .withUnretained(self)
            .map { coreDataService, data in
                let object = NSEntityDescription.insertNewObject(
                    forEntityName: "\(type(of: data))MO",
                    into: coreDataService.container.viewContext
                )
                let mirror = Mirror(reflecting: data)
                mirror.children.forEach { key, value in
                    guard let key,
                          let propertyName = String(describing: key)
                        .split(separator: ".")
                        .last
                    else { return }
                    object.setValue(value, forKey: String(propertyName))
                }
                do {
                    try coreDataService.container.viewContext.save()
                    return data
                } catch {
                    coreDataService.container.viewContext.rollback()
                    throw error
                }
            }
    }
    
    public func update<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) -> Observable<T> {
        fetchManagedObject(type: type(of: data))
            .withUnretained(self)
            .map { coreDataSerivce, managedObject in
                guard let object = managedObject.first(
                    where: { object in
                        guard let savedData = object.value(
                            forKey: uniqueKeyPath.propertyName
                        ) as? U
                        else { return false }
                        return savedData == data[keyPath: uniqueKeyPath]
                    }
                )
                else { throw CoreDataServiceError.invalidData }
                let mirror = Mirror(reflecting: data)
                mirror.children.forEach { key, value in
                    guard let key,
                          let propertyName = String(describing: key)
                        .split(separator: ".")
                        .last
                    else { return }
                    object.setValue(
                        value,
                        forKey: String(propertyName)
                    )
                }
                if coreDataSerivce.container.viewContext.hasChanges {
                    do {
                        try coreDataSerivce.container.viewContext.save()
                        return data
                    } catch {
                        throw error
                    }
                } else {
                    throw CoreDataServiceError.unAlteredData
                }
            }
    }
    
    public func delete<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) -> Observable<T> {
        fetchManagedObject(type: type(of: data))
            .withUnretained(self)
            .map { coreDataSerivce, managedObject in
                guard let object = managedObject.first(
                    where: { object in
                        guard let savedData = object.value(
                            forKey: uniqueKeyPath.propertyName
                        ) as? U
                        else { return false }
                        return savedData == data[keyPath: uniqueKeyPath]
                    }
                )
                else { throw CoreDataServiceError.invalidData }
                coreDataSerivce.container.viewContext.delete(object)
                return data
            }
    }
    
    private func fetchManagedObject<T: CoreDataStorable>(
        type: T.Type
    ) -> Observable<[NSManagedObject]> {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: "\(type)MO"
        )
        do {
            let managedObjects = try self.container.viewContext.fetch(request)
            return .just(managedObjects)
        } catch {
            return .error(error)
        }
    }
}
