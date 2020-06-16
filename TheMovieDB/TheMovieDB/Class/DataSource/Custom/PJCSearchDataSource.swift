//
//  PJCSearchDataSource.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 18/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCSearchDataSource: PJCTableViewDataSource
{
    // MARK: - Property(s)
     
    private(set) var queryItems: [URLQueryItem]!
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        guard let delegate = self.section(at: indexPath.section) as? PJCDataSourceSelectDelegate else
        { return }
        
        delegate.dataSource(self, didSelectRowAt: indexPath.row)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension PJCSearchDataSource: UITableViewDataSourcePrefetching
{
    func tableView(_ tableView: UITableView,
                   prefetchRowsAt indexPaths: [IndexPath])
    {
        self.sections.enumerated().forEach
        { (index, section) in
                
            guard let delegate = section as? PJCDataSourcePrefetchDelegate else
            { return }
            
            guard let indexPath = indexPaths.filter({ $0.section == index }).first,
                let visibleRow = tableView.indexPathsForVisibleRows?[indexPath.section].row else
            { return }
            
            guard (indexPath.row + 1) >= section.numberOfObjects(),
                indexPath.row > 0 && visibleRow > 0 else
            { return }
            
            delegate.dataSource(self, prefetchRowsAt: indexPath)
            { (result) in
                
                if let indexPaths = try? result.get()
                { tableView.insertRows(at: indexPaths, with: .none) }
            }
        }
    }
}

// MARK: - PJCAPILoadingDelegate
extension PJCSearchDataSource: PJCAPILoadingDelegate
{
    func appendLoad<T>(_ request: PJCGenericAPIRequest<T>,
                       completion: @escaping PJCAPILoadingRequestHandler)
    {
        self.queryItems = request.queryItems
        
        self.sections.compactMap({ $0 as? PJCDataSourceSection<T> })
            .compactMap({ $0 as? PJCDataSourcePrefetchDelegate })
            .forEach { $0.dataSource(self, prefetchRowsAt: [], completion: completion) }
    }
}

