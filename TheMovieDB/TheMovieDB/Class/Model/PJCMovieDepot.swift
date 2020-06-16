//
//  PJCMovieDepot.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 10/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias PJCRepositoryResult<T> = Result<PJCAPIDataResponse<T>, Error>

typealias PJCAPIResponseHandler<T> = (PJCRepositoryResult<T>) -> Void

protocol PJCRepository
{
    associatedtype RepoType
    
    func fetch(_ request: PJCDataStoreRequest,
               completion: @escaping PJCAPIResponseHandler<RepoType>) // Bridge between store/api.
}

class PJCMovieDepot
{
    // MARK: - Property(s)
    
    private(set) var api: PJCMovieAPI = PJCMovieAPI()
    
    private(set) var dataStore: PJCMovieDataStore = PJCMovieDataStore() // NB:Should this be a protocol ..?
    
    private(set) var dataSource: PJCMovieDataSource = PJCMovieDataSource(with: [PJCMovieDataSourceSection([])])
    
    weak var queryItemsDelegate: PJCURLQueryItemsProvider?
}

// MARK: - PJCRepository
extension PJCMovieDepot: PJCRepository
{
    func fetch(_ request: PJCDataStoreRequest,
               completion: @escaping PJCAPIResponseHandler<PJCMovie>)
    {
        let queryItems = self.queryItemsDelegate?.urlQueryItems()
        let apiRequest = PJCAPIRequest(PJCMovieAPIPath.search.rawValue,
                                       queryItems: queryItems)
        
        let cache: PJCAPIMovieResponseHandler =
        { [weak self] (result) in
            
            guard let elements: [PJCMovie] = try? result.get().objects else
            {
                completion(.failure(PJCServiceError.unkown))
                return
            }
            
            self?.dataStore.insert(elements)
            { (error) in
                
                guard (error as? PJCDataStoreError) == .success else
                { return }
                
                if let section = self?.dataSource.section(at: 0) as? PJCMovieDataSourceSection
                { section.objects.append(contentsOf: elements) }
                
                let start = request.offset
                let end = start + (elements.count-1)
                let indexPaths = Array(start...end).map { IndexPath(item: $0, section: 0) }
                let response = PJCAPIDataResponse<PJCMovie>(indexPaths: indexPaths)
                
                completion(.success(response))
            }
        }
        
        self.api.request(apiRequest,
                         completion: cache)
    }
}

