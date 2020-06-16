//
//  PJCAPISearch.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 11/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias PJCAPISearchResult<T:Codable> = Result<PJCAPIDataResponse<PJCAPISearch<T>>, Error>

typealias PJCAPISearchResponseHandler<T:Codable> = (PJCAPISearchResult<T>) -> Void

protocol PJCSearchAPIRequestDelegate
{
    func request<T: PJCAPIPathComponent>(_ request: PJCGenericAPIRequest<T>,
                                         completion: @escaping PJCAPISearchResponseHandler<T>)
}

struct PJCAPISearch<T:Codable>: Codable
{
    let page: Int
    
    let totalResults: Int
    
    let totalPages: Int
    
    let results: [T]
    
    enum CodingKeys: String, CodingKey
    {
        case page
        case totalResults   = "total_results"
        case totalPages     = "total_pages"
        case results
    }
}

class PJCSearchAPI
{
    // MARK: - Property(s)
    
    private(set) var consumer: PJCConsumerQueue = PJCConsumerQueue()
    
    private(set) var dataProvider: PJCDataTaskProvider
    
    
    // MARK: - Initialisation
    
    init<T:PJCDataTaskProvider>(_ provider: T)
    { self.dataProvider = provider }
}

// MARK: - PJCAPIPathComponent
extension PJCSearchAPI: PJCAPIPathComponent
{
    static var relativePath: String
    { return "/4/search/" }
}

// MARK: - PJCMoviesProvider
extension PJCSearchAPI: PJCSearchAPIRequestDelegate
{
    func request<T: PJCAPIPathComponent>(_ request: PJCGenericAPIRequest<T>,
                                         completion: @escaping PJCAPISearchResponseHandler<T>)
    {
        let path = Self.relativePath + request.type.relativePath
        let request = PJCAPIRequest(path, queryItems: request.queryItems)
        
        guard let consumer = PJCSearchAPIConsumer(self.dataProvider,
                                                  request: request,
                                                  completion: completion) else
        {
            completion(.failure(PJCServiceError.badRequest))
            return
        }
        
        self.consumer.append() { consumer.task.resume() }
    }
}

// MARK: - Utility
extension PJCSearchAPI
{
    static func pagedQueryItems<T>(_ queryItems: [URLQueryItem],
                                   with search: PJCAPISearch<T>?) -> [URLQueryItem]
    {
        let key: String = PJCAPISearch<T>.CodingKeys.page.rawValue
        let page: Int = search?.page ?? 1
        let totalPages: Int = search?.totalPages ?? 1
        var buffer: [URLQueryItem] = queryItems.filter({ $0.name != key })
        
        if page < totalPages
        { buffer.append(URLQueryItem(name: key, value: "\(page + 1)")) }
        
        return buffer
    }
}

