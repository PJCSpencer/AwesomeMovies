//
//  PJCPerson.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 12/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


enum PJCGender: String
{
    case unkown
    case female
    case male
}

extension PJCGender
{
    init(_ source: PJCPerson) // TODO:Support protocol ...
    {
        switch source.gender
        {
        case 1:
            self = .female
        case 2:
            self = .male
        default:
            self = .unkown
        }
    }
}

struct PJCPersonName
{
    let forename: String
    
    let middleNames: [String]
    
    let surname: String
    
    init(_ source: PJCPerson) // TODO:Support failable initialiser ...
    {
        let parts = source.name.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        self.forename = parts.first ?? ""
        self.surname = parts.last ?? ""
        self.middleNames = parts.dropFirst().dropLast()
    }
    
    func showbizz() -> String
    { return self.forename + " " + self.surname }
    
    func initials() -> String
    {
        return String(self.forename[self.forename.startIndex])
            + String(self.surname[self.surname.startIndex])
    }
}

struct PJCPerson: Codable
{
    let posterPath: String?
    
    let popularity: Double
    
    let knownForDepartment: String?
    
    let gender: Int
    
    let id: Int
    
    let profilePath: String?
    
    let adult: Bool
    
    let knownFor: [PJCUnknownMedia]
    
    let name: String
    
    enum CodingKeys: String, CodingKey
    {
        case posterPath         = "poster_path"
        case popularity
        case knownForDepartment = "known_for_department"
        case gender
        case id
        case profilePath        = "profile_path"
        case adult
        case knownFor           = "known_for"
        case name
        
    }
}

// MARK: - PJCAPIPathComponent
extension PJCPerson: PJCAPIPathComponent
{
    static var relativePath: String
    { return "person" }
}

