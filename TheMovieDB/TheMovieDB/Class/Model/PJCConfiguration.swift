//
//  PJCConfiguration.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


let PJCAPIDefaultImageSize: String = "w500"

enum PJCAPIImageExtension: String
{
    case jpg
    case png
    
    static let support: [PJCAPIImageExtension] = [.jpg, .png]
}

struct PJCAPIImagesComponent
{
    // MARK: - Property(s)
    
    let filePath: String
    
    
    // MARK: - Initialisation
    
    init?(path: String)
    {
        guard let ext = path.components(separatedBy: ".").last,
            PJCAPIImageExtension.support.map({ $0.rawValue }).contains(ext) else
        { return nil }
        
        self.filePath = path
    }
}

struct PJCAPIImages: Codable
{
    // MARK: - Property(s)
    
    let secure_base_url: String
    
    let poster_sizes: [String]
    
    let backdrop_sizes: [String]
}

struct PJCAPIConfiguration: Codable
{
    let images: PJCAPIImages
}

