//
//  Foundation+Additions.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 12/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


extension Int
{
    func megabytes() -> Int
    { return self * 1024 * 1024 }
}

class PJCConsumerQueue // <T>
{
    fileprivate lazy var queue: OperationQueue =
    {
        let anObject = OperationQueue()
        anObject.maxConcurrentOperationCount = 1
        
        return anObject
    }()
    
    func append(_ block: @escaping () -> Void)
    { self.queue.addOperation(block) }
}

