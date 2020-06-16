//
//  PJCAPI.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


enum PJCAPIVersion: Int
{
    case three = 3
    case four = 4
}

enum PJCAPIKey: String
{
    case apiKey = "api_key"
    case results
}

enum PJCAPISecurityKey: String
{
    case v3auth = "copyAPIKeyHere"
    case v4auth = "copyAccessTokenHere"
}

enum PJCAPIError: Error
{
    case none
    case failed, canceled
    case unknown
}

typealias PJCAPIGenericResult<T> = Result<PJCAPIDataResponse<T>, Error>

typealias PJCAPIGenericResultHandler<T> = (PJCAPIGenericResult<T>) -> Void

typealias PJCAPIGenericResponseHandler<T:Codable> = (PJCAPIGenericResult<T>) -> Void

// MARK: - Protocol(s)
protocol PJCAPIPathComponent
{
    static var relativePath: String { get }
}

protocol PJCAPIRequestProvider
{
    static func apiRequest(queryItems: [URLQueryItem]) -> PJCAPIRequest
}

protocol PJCAPIRequestMethod
{
    var method: HTTPMethod { get }
}

protocol PJCGenericAPIRequestDelegate
{
    func request<T: PJCAPIPathComponent>(_ request: PJCGenericAPIRequest<T>,
                                         completion: @escaping PJCAPIGenericResponseHandler<T>)
}

protocol PJCQueryProvider
{
    var queryItems: [URLQueryItem] { get }
}

protocol PJCAPIConsumer
{
    associatedtype ConsumerType
    
    init?(_ provider: PJCDataTaskProvider,
          request: PJCAPIRequest,
          completion: @escaping PJCAPIGenericResultHandler<ConsumerType>)
}

typealias PJCAPILoadingResult = Result<[IndexPath], Error>

typealias PJCAPILoadingRequestHandler = (PJCAPILoadingResult) -> Void

protocol PJCAPILoadingDelegate
{
    func appendLoad<T>(_ request: PJCGenericAPIRequest<T>,
                       completion: @escaping PJCAPILoadingRequestHandler)
}

// MARK: - Struct(s)
struct PJCAPIRequest2: PJCAPIRequestMethod
{
    let method: HTTPMethod
}

extension PJCAPIRequest2
{
    static func GET() -> PJCAPIRequest2
    {
        return PJCAPIRequest2(method: .get)
    }
}

struct PJCAPIRequest
{
    let path: String // TODO:Evolve to support explicit domain type ..?
    
    let queryItems: [URLQueryItem]
    
    
    // MARK: - Initialisation
    
    init(_ path: String,
         queryItems: [URLQueryItem]? = nil)
    {
        self.path = path
        self.queryItems = queryItems ?? []
    }
}

struct PJCGenericAPIRequest<T: PJCAPIPathComponent>
{
    let type: T.Type
    
    let queryItems: [URLQueryItem]
    
    
    // MARK: - Initialisation
    
    init(_ type: T.Type,
         queryItems: [URLQueryItem] = [])
    {
        self.type = type
        self.queryItems = queryItems
    }
}

// MARK: - PJCURLRequestProvider
extension PJCAPIRequest: PJCURLRequestProvider
{
    func urlRequest(_ method: HTTPMethod?) -> URLRequest?
    { return URLComponents.from(self).urlRequest(nil) }
}

struct PJCAPIResponse<T> // NB:The following response struct names should be swapped.
{
    let data: PJCAPIDataResponse<T>?
    
    let error: Error?
}

struct PJCAPIDataResponse<T>
{
    // MARK: - Property(s)
    
    let objects: [T]
    
    let indexPaths: [IndexPath]
    
    
    // MARK: - Initialiser(s)
    
    init(_ objects: [T]? = nil,
         indexPaths: [IndexPath]? = nil)
    {
        self.objects = objects ?? []
        self.indexPaths = indexPaths ?? []
    }
}

