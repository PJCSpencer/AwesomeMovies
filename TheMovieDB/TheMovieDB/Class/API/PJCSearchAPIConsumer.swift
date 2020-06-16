//
//  PJCAPISearchConsumer.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 12/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


class PJCSearchAPIConsumer<T:Codable>: PJCAPIConsumer
{
    // MARK: - Property(s)
    
    private(set) var task: URLSessionTask!
    
    fileprivate var completion: PJCAPIGenericResultHandler<PJCAPISearch<T>>!
    
    
    // MARK: - Initialisation
    
    required init?(_ provider: PJCDataTaskProvider,
                   request: PJCAPIRequest,
                   completion: @escaping PJCAPIGenericResultHandler<PJCAPISearch<T>>)
    {
        guard let urlRequest = request.urlRequest(nil) else
        { return nil }
        
        self.task = provider.task(for: urlRequest,
                                  responseHandler: self.responseHandler)
        self.completion = completion
    }
    
    deinit
    {
        if self.task.state != .completed
        {
            self.task.cancel()
            
            DispatchQueue.main.async()
            { self.completion(.failure(PJCAPIError.canceled)) }
        }
    }
}

// MARK: - PJCResponseHandlerProvider
extension PJCSearchAPIConsumer: PJCResponseHandlerProvider
{
    func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
    {
        let table: [Int:PJCDataTaskResponseHandler] = [PJCServiceError.success.statusCode : self.serialise]
        
        return table[code]
    }
}

// MARK: - URL Response Consumer Method(s)
extension PJCSearchAPIConsumer
{
    func serialise(_ result: PJCDataTaskResult)
    {
        guard let search: PJCAPISearch<T> = try? result.get().decodedJSON() else
        {
            DispatchQueue.main.async()
            { self.completion(.failure(PJCAPIError.failed)) }
            return
        }
        
        DispatchQueue.main.async()
        { self.completion(.success(PJCAPIDataResponse([search]))) }
    }
}

