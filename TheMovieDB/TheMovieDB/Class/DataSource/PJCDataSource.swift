//
//  PJCDataSource.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias PJCPrefetchResult = Result<[IndexPath], Error>

typealias PJCDataSourcePrefetchHandler = (PJCPrefetchResult) -> Void

enum PJCPrefectBehaviour
{
    case local
    case remote
}

protocol PJCDataSourcePrefetchDelegate
{
    func dataSource(_ dataSource: PJCDataSource,
                    prefetchRowsAt indexPath: IndexPath,
                    completion: @escaping PJCDataSourcePrefetchHandler)
}

protocol PJCDataSourceSelectDelegate
{
    func dataSource(_ dataSource: PJCDataSource,
                    didSelectRowAt index: Int)
}

protocol PJCDataSourceRegistered
{
    associatedtype RegisterType
    
    func register(_ dataView: RegisterType)
}

protocol PJCDataSourceSelection: class
{
    func dataSource(_ dataSource: PJCDataSource,
                    didSelect indexPath: IndexPath)
}

class PJCDataSource: NSObject
{
    // MARK: - Property(s)
    
    private(set) var sections: [PJCDataSourceSectionType] = []
    
    
    // MARK: - Initialisation
    
    init(with objects: [PJCDataSourceSectionType])
    {
        super.init()
        
        self.sections.append(contentsOf: objects)
    }
    
    
    // MARK: - Accessing Sections
    
    func section(at index: Int = 0) -> PJCDataSourceSectionType?
    {
        if self.sections.count <= 0 { return nil }
        
        if index < 0 { return nil }
        if index >= self.sections.count { return nil }
        
        return self.sections[index]
    }
}

