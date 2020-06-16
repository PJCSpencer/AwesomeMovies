//
//  PJCMovie.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


struct PJCMovie: Codable
{
    let popularity: Double
    
    let voteCount: Int
    
    let posterPath: String?
    
    let id: Int
    
    let mediaType: String?
    
    let backdropPath: String?
    
    let title: String
    
    let voteAverage: Double
    
    let overview: String
    
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey
    {
        case popularity
        case voteCount      = "vote_count"
        case posterPath     = "poster_path"
        case id
        case mediaType      = "media_type"
        case backdropPath   = "backdrop_path"
        case title
        case voteAverage    = "vote_average"
        case overview
        case releaseDate    = "release_date"
    }
    
    
    // MARK: - Initialisation
    
    init()
    {
        self.popularity = 0
        self.voteCount = 0
        self.posterPath = nil
        self.id = 0
        self.mediaType = ""
        self.backdropPath = nil
        self.title = ""
        self.voteAverage = 0
        self.overview = ""
        self.releaseDate = ""
    }
}

// MARK: - APIRequestProvider
extension PJCMovie: PJCAPIRequestProvider
{
    static func apiRequest(queryItems: [URLQueryItem]) -> PJCAPIRequest
    {
        return PJCAPIRequest(PJCMovieAPIPath.search.rawValue,
                             queryItems: queryItems)
    }
}

// MARK: - Equatable
extension PJCMovie: Equatable
{
    static func == (lhs: PJCMovie,
                    rhs: PJCMovie) -> Bool // TODO:Expand ...
    { return lhs.id == rhs.id }
}

// MARK: - PJCAPIPathComponent
extension PJCMovie: PJCAPIPathComponent
{
    static var relativePath: String
    { return "movie" }
}

