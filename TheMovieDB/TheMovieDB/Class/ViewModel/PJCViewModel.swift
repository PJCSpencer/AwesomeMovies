//
//  PJCViewModel.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 21/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


protocol PJCViewModelInitialiser
{
    associatedtype ModelType
    
    var model: ModelType { get }
    
    init(model: ModelType)
}

protocol PJCViewModelProvider
{
    associatedtype ViewModelType: PJCViewModelInitialiser
    
    func viewModel(forObjectAt index: Int) -> ViewModelType?
}

class PJCViewModel<T>: PJCViewModelInitialiser
{
    private(set) var model: T
    
    required init(model: T)
    { self.model = model }
}

