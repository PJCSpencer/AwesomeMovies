//
//  PJCMovieViewController.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCMovieViewController: UIViewController
{
    // MARK: - Property(s)
    
    var viewModel: PJCMovieViewModel!
    
    
    // MARK: - Initialisation
    
    init(viewModel: PJCMovieViewModel)
    {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        self.view = PJCMovieDetailView(frame: UIScreen.main.bounds)
        self.viewRespectsSystemMinimumLayoutMargins = false
    }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        guard let view = self.view as? PJCMovieDetailView else
        { return }
        
        view.textView.text = self.viewModel.overview
        view.imageView.setImage(self.viewModel.posterUrl,
                                placeholder: nil)
    }
}

