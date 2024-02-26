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
    private var container: NSPersistentContainer
    
    public init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetch<T: CoreDataStorable>(type: T.Type) throws -> [T] {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: "\(type)MO"
        )
        do {
            return try self.container.viewContext.fetch(request)
                .compactMap { $0 as? CoreDataModelObject }
                .compactMap { $0.toEntity as? T }
        } catch {
            throw error
        }
    }
    
    public func save<T: CoreDataStorable>(data: T) {
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
        }
    }
    
    public func update(data: some CoreDataStorable) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "\(type(of: data))MO",
            in: container.viewContext
        )
        else { return }
        let object = NSManagedObject(
            entity: entity,
            insertInto: container.viewContext
        )
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
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
            }
        }
    }
    
    public func delete(data: some CoreDataStorable) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "\(type(of: data))MO",
            in: container.viewContext
        )
        else { return }
        let object = NSManagedObject(
            entity: entity,
            insertInto: container.viewContext
        )
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
        container.viewContext.delete(object)
    }
}
