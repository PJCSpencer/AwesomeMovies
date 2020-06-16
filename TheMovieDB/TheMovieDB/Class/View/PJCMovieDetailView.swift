//
//  PJCMovieDetailView.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCMovieDetailView: UIView
{
    // MARK: - Property(s)
    
    private(set) lazy var imageView: PJCImageView =
    {
        let anObject = PJCImageView(frame: .zero)
        anObject.contentMode = .scaleAspectFit
        anObject.backgroundColor = .black
        
        self.addSubview(anObject)
        return anObject
    }()
    
    private(set) lazy var textView: UITextView =
    {
        let anObject = UITextView(frame: .zero)
        anObject.font = UIFont.systemFont(ofSize: 15) // TODO:Resolve style type(s) ...
        anObject.isEditable = false
        anObject.isSelectable = false
        
        self.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Creating a View Object
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layoutMargins = .zero
        self.backgroundColor = .white
        
        self.updateLayout(nil)
    }
    
    required init?(coder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
}

// MARK: - PJCGeometryLayout Protocol
extension PJCMovieDetailView: PJCGeometryLayout
{
    func updateLayout(_ container: UIView?)
    {
        let guide = self.layoutMarginsGuide
        let scale: CGFloat = 0.65
        let offset: CGFloat = 12
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 0).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0).isActive = true
        self.imageView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: scale).isActive = true
        
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: offset).isActive = true
        self.textView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -offset).isActive = true
        self.textView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: offset).isActive = true
        self.textView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -offset).isActive = true
    }
}

