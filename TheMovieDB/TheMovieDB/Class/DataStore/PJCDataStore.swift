//
//  PJCDataStore.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias PJCDataStoreErrorHandler = (Error) -> Void

typealias PJCDataStoreResult<T> = Result<[T], Error>

typealias PJCDataStoreResultHandler<T> = (PJCDataStoreResult<T>) -> Void

typealias PJCCRUDRepository = PJCDataStoreCreate & PJCDataStoreRead & PJCDataStoreUpdate & PJCDataStoreDelete

protocol PJCCacheDelegate
{
    func cache<T>(_ elements: [T],
                  completion: @escaping PJCDataStoreErrorHandler)
}

protocol PJCDataStoreCreate
{
    associatedtype ElementType
    
    func insert(_ elements: [ElementType],
                completion: @escaping PJCDataStoreErrorHandler)
}

protocol PJCDataStoreRead
{
    associatedtype ResultType
    
    func fetch(_ request: PJCDataStoreRequest,
               completion: @escaping PJCDataStoreResultHandler<ResultType>)
}

protocol PJCDataStoreUpdate
{
    associatedtype ResultType
    
    func update(completion: @escaping PJCDataStoreResultHandler<ResultType>) // NSFetchRequest
}

protocol PJCDataStoreDelete
{
    associatedtype ResultType
    
    func delete(completion: @escaping PJCDataStoreResultHandler<ResultType>) // NSFetchRequest
}

enum PJCDataStoreError: Error
{
    case none
    case unkown
    case success, fail
}

struct PJCDataStoreRequest
{
    let offset: Int
    
    let limit: Int
    
    let sortDescriptors: [NSSortDescriptor]
    
    let predicate: NSPredicate?
}

extension PJCDataStoreRequest
{
    static func initial() -> PJCDataStoreRequest
    {
        return PJCDataStoreRequest(offset: 0,
                                   limit: 10,
                                   sortDescriptors: [],
                                   predicate: nil)
    }
}

