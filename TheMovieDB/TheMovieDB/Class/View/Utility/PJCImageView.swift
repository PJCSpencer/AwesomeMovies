//
//  PJCImageView.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCImageView: UIImageView
{
    // MARK: - Hidden Property(s)
    
    var session: URLSession = URLSession.shared
    
    fileprivate var task: URLSessionDataTask?
}

extension PJCImageView
{
    // MARK: - Requesting an Image
    
    func setImage(_ url: URL?,
                  placeholder: UIImage?)
    {
        self.task?.cancel()
        self.task = nil
        
        guard let url = url else
        {
            self.image = placeholder
            return
        }
        
        let request = URLRequest(url: url)
        if let cached = self.session.configuration.urlCache?.cachedResponse(for: request)
        {
            self.image = UIImage(data: cached.data)
            return
        }
        
        if self.image == nil
        { self.image = placeholder }
        
        self.task = self.session.dataTask(with: request)
        { [weak self] (data, response, error) in
            
            guard error == nil,
                let data = data else
            { return }
            
            DispatchQueue.main.async { self?.image = UIImage(data: data) }
        }
        self.task?.resume()
    }
}

