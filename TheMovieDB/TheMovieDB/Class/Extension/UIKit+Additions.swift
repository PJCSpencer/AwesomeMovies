//
//  UIKit+Additions.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


protocol PJCGeometryLayout
{
    func updateLayout(_ container: UIView?)
}

protocol PJCGeometry
{
    static var fixedSize: CGSize { get }
}

protocol PJCDynamicGeometry
{
    func calculatedSize() -> CGSize
}

protocol PJCGeometrySpacing
{
    static var marginSize: CGSize { get }
}

