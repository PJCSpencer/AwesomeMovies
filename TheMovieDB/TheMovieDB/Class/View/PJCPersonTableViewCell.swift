//
//  PJCPersonTableViewCell.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 23/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCPersonTableViewCell: UITableViewCell
{
    // MARK: - Property(s)
    
    private(set) lazy var customImageView: PJCImageView =
    {
        let anObject = PJCImageView(frame: .zero)
        anObject.contentMode = .scaleAspectFill
        anObject.clipsToBounds = true
        anObject.backgroundColor = UIColor(white: 0.95, alpha: 1) // TODO:Resolve style type(s) ...
        
        self.contentView.addSubview(anObject)
        return anObject
    }()
    
    private(set) lazy var utilityLabel: UILabel =
    {
        let anObject = UILabel(frame: .zero)
        anObject.font = UIFont(name: "HelveticaNeue", size: 14) // TODO:Resolve style type(s) ...
        anObject.textColor = UIColor(white: 0.6, alpha: 1)
        anObject.lineBreakMode = .byWordWrapping
        anObject.numberOfLines = 0
        anObject.textAlignment = .left
        
        self.contentView.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Initialisation
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.textLabel?.font = UIFont(name: "AmericanTypewriter-CondensedBold", size: 18) // TODO:Resolve style type(s) ...
        self.textLabel?.textColor = UIColor(white: 0.3, alpha: 1)
        
        self.updateLayout(nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: -
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let padding: CGFloat = 12
        let margins: CGFloat = self.contentView.layoutMargins.bottom + self.contentView.layoutMargins.top
        let dim: CGFloat = self.contentView.bounds.height - margins
        
        self.customImageView.layer.cornerRadius = (dim * 0.5)
        self.customImageView.frame = CGRect(origin: CGPoint(x: padding, y: padding),
                                            size: CGSize(width: dim, height: dim))
    }
}

// MARK: - PJCGeometryLayout 
extension PJCPersonTableViewCell: PJCGeometryLayout
{
    func updateLayout(_ container: UIView?)
    {
        let guide = self.contentView.layoutMarginsGuide
        let padding: CGFloat = 12
        
        self.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel?.leftAnchor.constraint(equalTo: self.customImageView.rightAnchor, constant: padding).isActive = true
        self.textLabel?.topAnchor.constraint(equalTo: guide.topAnchor, constant: 2).isActive = true
        
        if let label = self.textLabel
        {
            self.utilityLabel.translatesAutoresizingMaskIntoConstraints = false
            self.utilityLabel.leftAnchor.constraint(equalTo: self.customImageView.rightAnchor, constant: padding).isActive = true
            self.utilityLabel.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0).isActive = true
            self.utilityLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
        }
    }
}

// MARK: - PJCGeometry
extension PJCPersonTableViewCell: PJCGeometry
{
    static var fixedSize: CGSize
    { return CGSize(width: UIScreen.main.bounds.width, height: 100) }
}

