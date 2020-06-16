//
//  PJCMovieViewModel.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 21/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


class PJCMovieViewModel: PJCViewModel<PJCMovie>
{
    var overview: String
    { return self.model.overview }
    
    var posterUrl: URL?
    { return PJCConfigurationAPI.shared.url(forImageFile: self.model.posterPath) }
}

