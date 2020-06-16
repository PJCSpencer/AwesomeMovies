//
//  PJCPersonViewModel.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 13/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCPersonViewModel: PJCViewModel<PJCPerson>
{
    var profileUrl: URL?
    { return PJCConfigurationAPI.shared.url(forImageFile: self.model.profilePath) }
    
    var name: PJCPersonName
    { return PJCPersonName(self.model) }
    
    var gender: PJCGender
    { return PJCGender(self.model) }
    
    var knownFor: String
    {
        let count = min(self.model.knownFor.count, 3)
        let result = self.model.knownFor[0..<count].compactMap({ $0.title })
            .map({ $0 + ", " })
            .reduce("", +)
        
        return result.count <= 0 ? "Unkown" : String(result.dropLast(2))
    }
    
    var knownForDepartment: String
    { return self.model.knownForDepartment ?? "" }
    
    fileprivate lazy var label: UILabel =
    {
        let dim = PJCPersonTableViewCell.fixedSize.height
        let rect = CGRect(origin: .zero,
                          size: CGSize(width: dim, height: dim))
        
        let anObject = UILabel(frame: rect)
        anObject.font = UIFont(name: "AmericanTypewriter-Condensed", size: 40) // TODO:Resolve style type(s) ...
        anObject.textColor = UIColor.white
        anObject.textAlignment = .center
        
        return anObject
    }()
    
    func placeholderImage() -> UIImage?
    {
        self.label.text = self.name.initials()
        let size = self.label.bounds.size
        
        return UIGraphicsImageRenderer(size: size).image
        { [weak self] context in
            
            context.cgContext.setFillColor(UIColor(white: 0.9, alpha: 1).cgColor)
            context.cgContext.addEllipse(in: CGRect(origin: .zero, size: size))
            context.cgContext.drawPath(using: .fill)
            
            self?.label.layer.render(in: context.cgContext)
        }
    }
}

