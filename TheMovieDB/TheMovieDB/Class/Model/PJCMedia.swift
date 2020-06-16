//
//  PJCMedia.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 13/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


struct PJCUnknownMedia: Codable
{
    let posterPath: String?
    
    let id: Int
    
    let mediaType: String?
    
    let backdropPath: String?
    
    let overview: String
    
    let title: String?
    
    let name: String?
    
    enum CodingKeys: String, CodingKey
    {
        case posterPath     = "poster_path"
        case id
        case mediaType      = "media_type"
        case backdropPath   = "backdrop_path"
        case overview
        case title
        case name
    }
}

