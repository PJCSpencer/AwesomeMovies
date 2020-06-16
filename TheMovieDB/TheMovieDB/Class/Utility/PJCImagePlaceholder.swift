//
//  PJCImagePlaceholder.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 21/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCImagePlaceholder
{
    // MARK: - Property(s)
    
    fileprivate var images: [UIImage]
    
    fileprivate var index: Int = 0
    
    
    // MARK: - Initialisation
    
    init(images: [UIImage])
    { self.images = images }
    
    init(named: [String])
    { self.images = named.compactMap({ UIImage(named: $0)} ) }
    
    
    // MARK: - Returning an Image
    
    func next() -> UIImage?
    {
        self.index += 1
        self.index = self.index >= self.images.count ? 0 : self.index
        
        return self.images[self.index]
    }
}

