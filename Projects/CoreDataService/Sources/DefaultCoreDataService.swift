//
//  DefaultCoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

import CoreData

public final class DefaultCoreDataService: CoreDataService {
    private let container: NSPersistentContainer
    
    public init() {
        container = NSPersistentCloudKitContainer(name: "Model")
//        let localStoreLocation = URL(fileURLWithPath: "/path/to/local.store")
//        let localStoreDescription = NSPersistentStoreDescription(
//            url: localStoreLocation
//        )
//        localStoreDescription.configuration = "Local"
//        let cloudStoreLocation = URL(fileURLWithPath: "/path/to/cloud.store")
//        let cloudStoreDescription = NSPersistentStoreDescription(
//            url: cloudStoreLocation
//        )
//        cloudStoreDescription.configuration = "Cloud"
//        cloudStoreDescription.cloudKitContainerOptions 
//        = NSPersistentCloudKitContainerOptions(
//            containerIdentifier: "com.my.container"
//        )
//        container.persistentStoreDescriptions = [
//            localStoreDescription,
//            cloudStoreDescription
//        ]
        container.loadPersistentStores { _, error in
            if let error {
                print(error.localizedDescription)
                return
            }
//            self.migrateStore()
        }
    }
    
    private func migrateStore() {
        let dataBaseName = "Model.sqlite"
        guard let directory = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first
        else { return }
        let oldStoreUrl = directory.appendingPathComponent(dataBaseName)
        guard let oldStore = container.persistentStoreCoordinator
            .persistentStore(for: oldStoreUrl)
        else { return }
        print(oldStore)
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
            var object = mo.first { object in
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
