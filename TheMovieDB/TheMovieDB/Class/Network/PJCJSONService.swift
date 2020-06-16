//
//  PJCJSONService.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias JSONObject = [String:Any]

typealias JSONCollection = [JSONObject]

typealias PJCJSONResult = Result<JSONObject, Error>

typealias PJCJSONServiceResponseHandler = (PJCJSONResult) -> Void

typealias PJCJSONSerialisationHandler = (PJCJSONServiceError) -> Void

protocol PJCJSONProvider
{
    func resource(request: URLRequest,
                  completion: @escaping PJCJSONServiceResponseHandler) -> URLSessionTask
}

protocol PJCJSONSerialisation
{
    func cache(fromJSONCollection collection: JSONCollection,
               completion: PJCJSONSerialisationHandler?)
}

enum PJCJSONServiceError: Error
{
    case none
    case failed
    case unkown
}

class PJCJSONService
{
    // MARK: - Property(s)
    
    var completionHandler: PJCJSONServiceResponseHandler?
    
    private(set) lazy var dataProvider: PJCDataTaskProvider =
    {
        let anObject = PJCDataService()
        return anObject
    }()
}

// MARK: - PJCJSONProvider
extension PJCJSONService: PJCJSONProvider
{
    func resource(request: URLRequest,
                  completion: @escaping PJCJSONServiceResponseHandler) -> URLSessionTask
    {
        self.completionHandler = completion
        
        return self.dataProvider.task(for: request,
                                      responseHandler: self.responseHandler)
    }
}

// MARK: - PJCResponseHandlerProvider
extension PJCJSONService: PJCResponseHandlerProvider
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
    
    
    // MARK: - URL Response Consumer Method(s)
    
    func serialise(_ result: PJCDataTaskResult)
    {
        guard let taskData = try? result.get(),
            taskData.type == ContentType(MIMETypeApplication.json),
            let json = try? JSONSerialization.jsonObject(with: taskData.data,
                                                         options: .allowFragments) as? JSONObject ?? [:] else
        {
            self.completionHandler?(.failure(PJCJSONServiceError.failed))
            return
        }
        self.completionHandler?(.success(json))
    }
    
    func unauthorised(_ result: PJCDataTaskResult) { /* TODO: */ }
}

