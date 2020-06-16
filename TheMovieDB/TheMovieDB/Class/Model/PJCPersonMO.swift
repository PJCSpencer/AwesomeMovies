//
//  PJCPersonMO.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 13/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation
import CoreData


class PJCPersonMO: NSManagedObject { /* TODO: */ }

// MARK: - FetchRequestMapping
extension PJCPersonMO: PJCFetchRequestMapping
{
    static var entityName: String = "PJCPersonMO"
}

