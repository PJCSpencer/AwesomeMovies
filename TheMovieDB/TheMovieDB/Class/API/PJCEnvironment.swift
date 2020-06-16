//
//  PJCEnvironment.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


enum PJCHost: String
{
    case develop = "api.themoviedb.org" // TODO:Expand ...
}

enum PJCEnvironment
{
    case develop
    
    
    // MARK: - Returning the Current Environment
    
    static var current: PJCEnvironment
    {
        return .develop
    }
    
    
    // MARK: - Returning the Host
    
    static var host: PJCHost
    {
        switch PJCEnvironment.current
        {
        case .develop:
            return .develop
        }
    }
}

