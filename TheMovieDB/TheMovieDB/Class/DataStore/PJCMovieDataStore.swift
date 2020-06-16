//
//  PJCMovieDataStore.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 29/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit
import CoreData


class PJCMovieDataStore {}

// MARK: - PJCDataStoreCreate
extension PJCMovieDataStore: PJCDataStoreCreate
{
    func insert(_ elements: [PJCMovie],
                completion: @escaping PJCDataStoreErrorHandler)
    {
        let dataStore = UIApplication.shared.dataStore
        
        elements.forEach
        { (template) in
            
            let success: PJCCoreDataStoreErrorHandler =
            { (error) in
                
                guard (error as? PJCDataStoreError) == PJCDataStoreError.success else
                {
                    completion(PJCDataStoreError.fail) // TODO:Resolve, could be called multiple times ...
                    return
                }
                
                if template == elements.last
                { completion(PJCDataStoreError.success) }
            }
            
            let update: PJCCoreDataStoreResultHandler<PJCMovieMO> =
            { (result) in
                
                guard let result = try? result.get(),
                    let object = result.first else
                {
                    completion(PJCDataStoreError.fail)
                    return
                }
                
                dataStore.update(object,
                                 with: template,
                                 completion: success)
            }
            
            dataStore.insert(PJCMovieMO.self,
                             completion: update)
        }
    }
}

// MARK: - PJCDataStoreRead
extension PJCMovieDataStore: PJCDataStoreRead
{
    func fetch(_ request: PJCDataStoreRequest,
               completion: @escaping PJCDataStoreResultHandler<PJCMovie>)
    {
        let fetchRequest = PJCMovieMO.dataStoreFetchRequest(request)
        
        let handler: PJCCoreDataStoreResultHandler<PJCMovie> =
        { (result) in
            
            guard let movies = try? result.get() else
            {
                completion(.failure(PJCDataStoreError.fail))
                return
            }
            completion(.success(movies))
        }
        
        UIApplication.shared.dataStore.fetch(fetchRequest,
                                             completion: handler)
    }
}

