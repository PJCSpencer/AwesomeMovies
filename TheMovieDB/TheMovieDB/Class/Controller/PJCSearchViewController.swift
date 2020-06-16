//
//  PJCSearchViewController.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCSearchViewController: UIViewController
{
    // MARK: - Property(s)
     
    var dataSource: PJCSearchDataSource?
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        self.view = PJCMoviesView(frame: UIScreen.main.bounds)
        self.viewRespectsSystemMinimumLayoutMargins = false
        
        if let view = self.view as? PJCMoviesView
        {
            self.dataSource?.register(view.tableView)
            view.tableView.prefetchDataSource = self.dataSource
        }
    }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let queryItems = [URLQueryItem(name: "query", value: "tom")] // TODO:Capture query domain type ...
        let request = PJCGenericAPIRequest(PJCPerson.self,
                                           queryItems: queryItems)
        
        // TODO:Support sort and predicate ...
        
        self.dataSource?.appendLoad(request)
        { (_) in (self.view as? PJCMoviesView)?.tableView.reloadData() }
    }
}

