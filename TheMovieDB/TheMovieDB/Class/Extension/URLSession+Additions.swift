//
//  URLSession+Additions.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


protocol PJCURLQueryItemsProvider: class
{
    func urlQueryItems() -> [URLQueryItem]
}

protocol PJCURLRequestProvider
{
    func urlRequest(_ method: HTTPMethod?) -> URLRequest?
}

// MARK: - URLSessionConfiguration
extension URLSessionConfiguration
{
    class func named(_ path: String) -> URLSessionConfiguration
    {
        let anObject: URLSessionConfiguration = URLSessionConfiguration.default
        anObject.requestCachePolicy = .useProtocolCachePolicy
        anObject.timeoutIntervalForRequest = 10.0
        anObject.allowsCellularAccess = false
        anObject.waitsForConnectivity = true
        anObject.urlCache = URLCache(memoryCapacity: 1.megabytes(),
                                     diskCapacity: 10.megabytes(),
                                     diskPath: path)
        
        return anObject
    }
}

// MARK: - URLComponents
extension URLComponents
{
    static func from(_ request: PJCAPIRequest,
                     scheme: HTTPScheme = HTTPScheme.https,
                     host: PJCHost = PJCEnvironment.host) -> URLComponents
    {
        var components: URLComponents = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host.rawValue
        components.path = request.path
        components.queryItems = request.queryItems
        
        return components
    }
}

// MARK: - PJCRequestProvider
extension URLComponents: PJCURLRequestProvider
{
    func urlRequest(_ request: PJCAPIRequest) -> URLRequest?
    {
        return nil
    }
    
    func urlRequest(_ method: HTTPMethod?) -> URLRequest?
    {
        guard let url = self.url else
        { return nil }
        
        // TODO:Support version(s) ...
        
        /*let buffer: [URLQueryItem] =
        [
            URLQueryItem(name: PJCAPIKey.apiKey.rawValue,
                         value: PJCAPISecurityKey.v3auth.rawValue)
        ]*/
        
        // TODO:Support httpBody ...
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.httpMethod = method?.rawValue ?? HTTPMethod.get.rawValue
        request.setValue(AuthenticationScheme.bearer.rawValue + " " + PJCAPISecurityKey.v4auth.rawValue,
                         forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
        
        request.setValue(MIMETypeApplication.json.description,
                         forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        return request
    }
}

