//
//  PJCMoviesView.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCMoviesView: UIView
{
    // MARK: - Property(s)
    
    private(set) lazy var tableView: UITableView =
    {
        let anObject = UITableView(frame: .zero, style: .plain)
        anObject.rowHeight = 100
        anObject.separatorInset = .zero
        anObject.showsVerticalScrollIndicator = false
        
        self.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Creating a View Object
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: -
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.tableView.frame = self.bounds
    }
}

