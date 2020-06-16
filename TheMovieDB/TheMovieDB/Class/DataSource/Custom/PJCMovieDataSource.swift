//
//  PJCMovieDataSource.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCMovieDataSource: PJCTableViewDataSource
{
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        guard let rootViewController = UIApplication.shared.rootViewController,
            let section = self.sections.first as? PJCMovieDataSourceSection,
            let viewModel = section.viewModel(forObjectAt: indexPath.row) else
        { return }
        
        DispatchQueue.main.async
        {
            rootViewController.present(PJCMovieViewController(viewModel: viewModel),
                                       animated: true,
                                       completion: nil)
        }
    }
}

