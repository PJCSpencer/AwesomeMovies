//
//  PJCMoviesTableViewCell.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCMoviesTableViewCell: UITableViewCell
{
    // MARK: - Property(s)
    
    private(set) lazy var customImageView: PJCImageView =
    {
        let anObject = PJCImageView(frame: .zero)
        anObject.contentMode = .scaleAspectFill
        anObject.clipsToBounds = true
        
        self.contentView.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Initialisation
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 20) // TODO:Resolve style type(s) ...
        self.textLabel?.backgroundColor = .black
        self.textLabel?.textColor = .white
        self.textLabel?.numberOfLines = 0
        
        self.contentView.sendSubviewToBack(self.customImageView)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.customImageView.frame = self.contentView.bounds
        self.textLabel?.sizeToFit()
    }
}

