//
//  PJCPersonDataStore.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 13/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


class PJCPersonDataStore
{
    static let shared = PJCPersonDataStore()
}

// MARK: - PJCDataStoreCreate
extension PJCPersonDataStore: PJCDataStoreCreate
{
    func insert(_ elements: [PJCPerson],
                completion: @escaping PJCDataStoreErrorHandler)
    { print("\(self)::\(#function)")
        
        completion(PJCDataStoreError.success)
    }
}

