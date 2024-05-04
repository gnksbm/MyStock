//
//  DefaultCoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation
import CoreData

import Core

public final class DefaultCoreDataService: CoreDataService {
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
    
    public func fetch<T: CoreDataStorable>(type: T.Type) throws -> [T] {
        do {
            return try fetchMO(type: type)
                .compactMap { $0 as? CoreDataModelObject }
                .compactMap { $0.toDomain as? T }
        } catch {
            throw error
        }
    }
    
    public func save<T: CoreDataStorable>(data: T) throws {
        let object = NSEntityDescription.insertNewObject(
            forEntityName: "\(type(of: data))MO",
            into: container.viewContext
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
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            throw error
        }
    }
    
    public func update<T: CoreDataStorable, U>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws {
        do {
            let mo = try fetchMO(type: type(of: data))
            let object = mo.first { object in
                object.value(forKey: uniqueKeyPath.propertyName) != nil
            }
            let mirror = Mirror(reflecting: data)
            mirror.children.forEach { key, value in
                guard let key,
                      let propertyName = String(describing: key)
                    .split(separator: ".")
                    .last
                else { return }
                object?.setValue(
                    value,
                    forKey: String(propertyName)
                )
            }
            if container.viewContext.hasChanges {
                do {
                    try container.viewContext.save()
                } catch {
                    throw error
                }
            }
        } catch {
            throw error
        }
    }
    
    public func delete<T: CoreDataStorable, U>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws {
        do {
            let mo = try fetchMO(type: type(of: data))
            guard let object = mo.first(where: { object in
                object.value(forKey: uniqueKeyPath.propertyName) != nil
            })
            else { return }
            container.viewContext.delete(object)
        } catch {
            throw error
        }
    }
    
    public func duplicationCheck<T: CoreDataStorable, U>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws -> DuplicationStatus {
        do {
            let mo = try fetchMO(type: type(of: data))
            let isContain = mo.contains { object in
                object.value(forKey: uniqueKeyPath.propertyName) != nil
            }
            return isContain ? .duplicated : .none
        } catch {
            throw error
        }
    }
    
    private func fetchMO<T: CoreDataStorable>(
        type: T.Type
    ) throws -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: "\(type)MO"
        )
        do {
            return try self.container.viewContext.fetch(request)
        } catch {
            throw error
        }
    }
}
