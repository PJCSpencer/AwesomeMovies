//
//  PJCMovieMO.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 10/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation
import CoreData


class PJCMovieMO: NSManagedObject {}

// MARK: - FetchRequestMapping
extension PJCMovieMO: PJCFetchRequestMapping
{
    static var entityName: String = "PJCMovieMO"
}

// MARK: - PJCMapping
extension PJCMovieMO: PJCMapping
{
    func mapTo() -> PJCMovie?
    {
        return PJCMovie()
    }
    
    func mapFrom(_ object: PJCMovie) { /* TODO: */ }
}

// MARK: - PJCCoreDataStoreFetchRequestProvider
extension PJCMovieMO: PJCCoreDataStoreFetchRequestProvider
{
    static func dataStoreFetchRequest(_ dataStoreRequest: PJCDataStoreRequest?) -> NSFetchRequest<PJCMovieMO>
    {
        let fetchRequest = NSFetchRequest<PJCMovieMO>(entityName: PJCMovieMO.entityName)
        
        guard let dataStoreRequest = dataStoreRequest else
        { return fetchRequest }
        
        fetchRequest.fetchOffset = dataStoreRequest.offset
        fetchRequest.fetchLimit = dataStoreRequest.limit
        fetchRequest.sortDescriptors = dataStoreRequest.sortDescriptors
        fetchRequest.predicate = dataStoreRequest.predicate
        
        return fetchRequest
    }
}

