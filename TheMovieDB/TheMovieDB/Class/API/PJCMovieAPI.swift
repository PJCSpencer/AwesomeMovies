//
//  PJCMovieAPI.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias PJCAPIMovieResult = Result<PJCAPIDataResponse<PJCMovie>, Error>

typealias PJCAPIMovieResponseHandler = (PJCAPIMovieResult) -> Void

protocol PJCMovieProvider // NB:Resolve identity ..?
{
    func request(_ request: PJCAPIRequest,
                 completion: @escaping PJCAPIMovieResponseHandler)
}

enum PJCMovieAPIPath: String
{
    case search = "/4/search/movie" // TODO:Support version ...
}

class PJCMovieAPI
{
    // MARK: - Property(s)
    
    private(set) var consumers: [PJCMovieAPIConsumer] = []
    
    private(set) lazy var dataProvider: PJCDataTaskProvider =
    {
        let anObject = PJCDataService()
        return anObject
    }()
}

// MARK: - PJCMoviesProvider
extension PJCMovieAPI: PJCMovieProvider // URLSession language == request.
{
    func request(_ request: PJCAPIRequest,
                 completion: @escaping PJCAPIMovieResponseHandler)
    {
        guard let consumer = PJCMovieAPIConsumer(self.dataProvider,
                                                 request: request,
                                                 completion: completion) else
        {
            completion(.failure(PJCServiceError.badRequest))
            return
        }
        consumer.resume()
    }
}

