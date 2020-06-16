//
//  PJCDataSourceSection.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


typealias PJCDataSourceSectionType = PJCDataSourceSectionRegister & PJCCountable & PJCDataSourceSectionPresenter

// MARK: - Creating and Identifing Cell(s)
protocol PJCDataSourceSectionRegister
{
    var cellClass: AnyClass? { get }
    
    var nib: UINib? { get }
    
    var reuseIdenifier: String { get }
}

extension PJCDataSourceSectionRegister
{
    var cellClass: AnyClass? { return nil }
    
    var nib: UINib? { return nil }
    
    var reuseIdenifier: String
    { return String(describing: type(of: self)) }
}

// MARK: Presenting Cell(s)
protocol PJCDataSourceSectionPresenter
{
    func cell(_ cell: UIView,
              displayObjectAt index: Int)
    
    func cellSize(forObjectAt index: Int) -> CGSize
}

extension PJCDataSourceSectionPresenter
{
    func cellSize(forObjectAt index: Int) -> CGSize
    { return CGSize.zero }
}

// MARK: - Counting Utility
protocol PJCCountable
{
    func numberOfObjects() -> Int
}

class PJCDataSourceSection<T>: PJCCountable
{
    // MARK: - Property(s)
    
    var tag: Int?
    
    var title: String?
    
    var objects: [T]
    
    
    // MARK: - Initialisation
    
    init(_ objects: [T])
    { self.objects = objects }
    
    
    // MARK: - PJCCountable
    
    func numberOfObjects() -> Int
    { return self.objects.count }
}

