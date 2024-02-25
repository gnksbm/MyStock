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
    private var entity: NSEntityDescription?
    private var container: NSPersistentContainer
    
    public init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                print(error.localizedDescription)
            }
        }
        entity = nil
    }
    
    public func fetch<T: Storable>(type: T.Type) throws -> [T] {
        checkEntityName(type: type)
        let request = type.coreDataType.fetchRequest()
        do {
            return try self.container.viewContext.fetch(request)
                .compactMap { $0 as? CoreDataModelObject }
                .compactMap { $0.toEntity as? T }
        } catch {
            throw error
        }
    }
    
    public func save<T: Storable>(data: T) {
        checkEntityName(type: type(of: data))
        guard let entity else { return }
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
            object.setValue(value, forKey: String(propertyName))
        }
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
        }
    }
    
    public func update(data: some Storable) {
        checkEntityName(type: type(of: data))
        guard let entity else { return }
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
    
    public func delete(data: some Storable) {
        checkEntityName(type: type(of: data))
        guard let entity else { return }
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
    
    private func checkEntityName(type: Storable.Type) {
        guard let entityNameSubstr = ("\(type)".split(separator: ".").last)
        else { return }
        let entityName = String(entityNameSubstr) + "MO"
        guard container.name != entityName,
              entity?.name != entityName
        else { return }
        entity = .entity(
            forEntityName: entityName,
            in: container.viewContext
        )
    }
}
