//
//  PJCOAuthService.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 22/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


enum OAuth2Error: Error
{
    case requestOrIdentity
    case requestOrToken
    case serialize
    case unauthorised
}

enum AuthenticationScheme: String
{
    case basic  = "Basic"
    case bearer = "Bearer"
}

enum OAuth2Key: String
{
    case client_id, client_secret
    case username, password, grant_type, access_token, refresh_token
}

struct OAuth2Tokens
{
    let access: String
    let refresh: String
}

typealias OAuth2ServiceResponseCallback = (OAuth2Tokens?, Error?) -> Void

protocol OAuth2IdentityProvider: class
{
    func username() -> String?
    
    func password() -> String?
}

protocol OAuth2TokenProvider: class
{
    func token(forKey key: String) -> String?
    
    func setToken(_ value: String, forKey key: String)
}

protocol OAuth2TokenAccess
{
    func grant(completion: @escaping OAuth2ServiceResponseCallback) throws
    
    func refresh(completion: @escaping OAuth2ServiceResponseCallback) throws
}

