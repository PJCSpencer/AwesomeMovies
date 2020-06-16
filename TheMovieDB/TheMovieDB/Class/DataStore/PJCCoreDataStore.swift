//
//  PJCCoreDataStore.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 10/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation
import CoreData


protocol PJCCoreDataStoreFetchRequestProvider
{
    associatedtype DataType: NSFetchRequestResult
    
    static func dataStoreFetchRequest(_ dataStoreRequest: PJCDataStoreRequest?) -> NSFetchRequest<DataType>
}

protocol PJCFetchRequestMapping
{
    static var entityName: String { get }
}

protocol PJCMapping
{
    associatedtype TMappingType
    
    associatedtype FMappingType
    
    func mapTo() -> TMappingType?
    
    func mapFrom(_ object: FMappingType)
}

typealias PJCCoreDataStoreResult<U> = Result<[U], Error>

typealias PJCCoreDataStoreResultHandler<U> = (PJCCoreDataStoreResult<U>) -> Void

typealias PJCCoreDataStoreErrorHandler = (Error) -> Void

class PJCCoreDataStore
{
    // MARK: - Property(s)
    
    fileprivate let modelName: String = "Model"
    
    fileprivate lazy var objectModel: NSManagedObjectModel =
    {
        guard let url = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else
        { fatalError("Error finding object model.") }
        
        guard let anObject = NSManagedObjectModel(contentsOf: url) else
        { fatalError("Error loading object model.") }
        
        return anObject
    }()
    
    fileprivate lazy var coordinator: NSPersistentStoreCoordinator =
    {
        let anObject = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let location = url.appendingPathComponent("\(self.modelName).sqlite")
        
        do
        {
            try anObject.addPersistentStore(ofType: NSSQLiteStoreType,
                                            configurationName: nil,
                                            at: location,
                                            options: nil)
        }
        catch
        { fatalError("Error adding persistent store.") }
        
        return anObject
    }()
    
    fileprivate lazy var mainContext: NSManagedObjectContext =
    {
        let anObject = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        anObject.persistentStoreCoordinator = self.coordinator
        
        return anObject
    }()
    
    
    // MARK: - Context Utility
    
    func createBackgroundContext() -> NSManagedObjectContext
    {
        let anObject = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        anObject.parent = self.mainContext
        return anObject
    }
}

// MARK: - Core General Purpose Function(s)
extension PJCCoreDataStore
{
    func insert<T>(_ type: T.Type,
                   completion: @escaping PJCCoreDataStoreResultHandler<T>) where T: NSManagedObject, T: PJCMapping
    {
        let context = self.createBackgroundContext()
        context.performAndWait
        {
            do
            {
                let name = String(describing: T.self)
                guard let object = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as? T else
                {
                    completion(.failure(PJCDataStoreError.fail))
                    return
                }
                
                try self.save(context)
                
                completion(.success([object]))
            }
            catch
            { completion(.failure(PJCDataStoreError.fail)) }
        }
    }
    
    func fetch<T, U>(_ request: NSFetchRequest<T>,
                     completion: @escaping PJCCoreDataStoreResultHandler<U>) where T: NSManagedObject, T: PJCMapping
    {
        let context = self.createBackgroundContext()
        context.performAndWait
        {
            do
            {
                let results = try context.fetch(request).compactMap { $0.mapTo() as? U }
                completion(.success(results))
            }
            catch
            { completion(.failure(PJCDataStoreError.fail)) }
        }
    }
    
    func update<T, U>(_ object: T,
                      with template: U,
                      completion: @escaping PJCCoreDataStoreErrorHandler) where T: NSManagedObject, T: PJCMapping
    {
        let context = self.createBackgroundContext()
        context.performAndWait
        {
            do
            {
                guard let template = template as? T.FMappingType else
                {
                    completion(PJCDataStoreError.fail)
                    return
                }
                
                object.mapFrom(template)
                try self.save(context)
                
                completion(PJCDataStoreError.success)
            }
            catch
            { completion(PJCDataStoreError.fail) }
        }
    }
    
    func delete<T: NSManagedObject>(_ request: NSFetchRequest<T>,
                                    completion: @escaping PJCCoreDataStoreErrorHandler)
    { /* TODO: */ }
}

// MARK: - Saving
extension PJCCoreDataStore
{
    fileprivate func save(_ context: NSManagedObjectContext) throws
    {
        var saveError: Error?
        
        context.performAndWait
        {
            if context.hasChanges
            {
                do { try context.save() }
                catch { saveError = error }
            }
        }
        
        self.mainContext.performAndWait
        {
            if self.mainContext.hasChanges
            {
                do { try self.mainContext.save() }
                catch { saveError = error }
            }
        }
        
        if let saveError = saveError
        { throw saveError }
    }
}

