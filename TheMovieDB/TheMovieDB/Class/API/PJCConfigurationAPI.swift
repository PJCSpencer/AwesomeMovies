//
//  PJCConfigurationAPI.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


enum PJCConfigurationAPIPath: String
{
    case configuration = "/3/configuration" // TODO:Support version ...
}

class PJCConfigurationAPI
{
    // MARK: - Shared Instance
    
    static let shared = PJCConfigurationAPI()
    
    
    // MARK: - Property(s)
    
    private(set) var configuration: PJCAPIConfiguration?
    
    private(set) var dataProvider: PJCDataTaskProvider = PJCDataService()
    
    
    // MARK: - Initialisation
    
    private init() {}
}

extension PJCConfigurationAPI
{
    // MARK: - Caching API Configuration Information
    
    func cache()
    {
        let path = PJCConfigurationAPIPath.configuration.rawValue
        guard let urlRequest = PJCAPIRequest(path).urlRequest(nil) else
        { return }
        
        let handler: PJCDataTaskResponseHandlerProvider =
        { (_) in /* Ignore status code. */
            
            return { [weak self] (result) in self?.configuration = try? result.get().decodedJSON() }
        }
        
        self.dataProvider.task(for: urlRequest,
                               responseHandler: handler).resume()
    }
    
    
    // MARK: - Utility
    
    func url(forImageFile path: String?,
             posterSize: String = PJCAPIDefaultImageSize) -> URL? // TODO:Explore tiny type ..?
    {
        guard let size = self.configuration?.images.poster_sizes.filter({ $0.contains(posterSize) }).first,
            let base = self.configuration?.images.secure_base_url,
            let url = URL(string: base + size),
            let path = path,
            let component = PJCAPIImagesComponent(path: path) else
        { return nil }
        
        return url.appendingPathComponent(component.filePath)
    }
}

