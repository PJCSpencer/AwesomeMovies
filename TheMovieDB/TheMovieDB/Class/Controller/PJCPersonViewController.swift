//
//  PJCPersonViewController.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 13/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCPersonViewController: UIViewController
{
    // MARK: - Property(s)
    
    var viewModel: PJCPersonViewModel!
    
    
    // MARK: - Initialisation
    
    init(viewModel: PJCPersonViewModel)
    {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
}

