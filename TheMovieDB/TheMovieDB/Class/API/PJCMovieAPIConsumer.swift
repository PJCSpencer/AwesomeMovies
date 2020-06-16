//
//  PJCMovieAPIConsumer.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 28/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


class PJCMovieAPIConsumer // TODO:Completed ..?
{
    // MARK: - Property(s)
    
    private(set) var task: URLSessionTask!
    
    fileprivate var completion: PJCAPIMovieResponseHandler!
    
    
    // MARK: - Initialisation
    
    init?(_ provider: PJCDataTaskProvider,
          request: PJCAPIRequest,
          completion: @escaping PJCAPIMovieResponseHandler)
    {
        guard let urlRequest = request.urlRequest(nil) else
        { return nil }
        
        self.task = provider.task(for: urlRequest,
                                  responseHandler: self.responseHandler)
        
        self.completion = completion
    }
    
    
    // MARK: - Wrapper Support
    
    func resume()
    { self.task.resume() }
}

// MARK: - PJCResponseHandlerProvider
extension PJCMovieAPIConsumer: PJCResponseHandlerProvider
{
    func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
    {
        let table: [Int:PJCDataTaskResponseHandler] =
        [
            PJCServiceError.success.statusCode      : self.serialise,
            PJCServiceError.unauthorized.statusCode : self.unauthorised
        ]
        return table[code]
    }
}

// MARK: - URL Response Consumer Method(s)
extension PJCMovieAPIConsumer
{
    func serialise(_ result: PJCDataTaskResult)
    {
        guard let search: PJCAPISearch<PJCMovie> = try? result.get().decodedJSON() else
        {
            self.completion(.failure(PJCAPIError.failed))
            return
        }
        
        DispatchQueue.main.async()
        { self.completion(.success(PJCAPIDataResponse(search.results))) }
    }
    
    func unauthorised(_ result: PJCDataTaskResult)
    { /* TODO: */ }
}

