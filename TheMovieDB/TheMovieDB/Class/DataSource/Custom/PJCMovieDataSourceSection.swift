//
//  PJCMovieDataSourceSection.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


fileprivate typealias CellType = PJCMoviesTableViewCell

class PJCMovieDataSourceSection: PJCDataSourceSection<PJCMovie>
{
    var placeholder: PJCImagePlaceholder = PJCImagePlaceholder(named: ["RedMoviePlaceholder", "BlueMoviePlaceholder"])
}

// MARK: - PJCDataSourceSectionRegister
extension PJCMovieDataSourceSection: PJCDataSourceSectionRegister
{
    var cellClass: AnyClass?
    { return CellType.self }
}

// MARK: - PJCDataSourceSectionPresenter
extension PJCMovieDataSourceSection: PJCDataSourceSectionPresenter
{
    func cell(_ cell: UIView,
              displayObjectAt index: Int)
    {
        guard let cell = cell as? CellType,
            let movie = self.objects[index] as PJCMovie? else
        { return }
        
        cell.textLabel?.text = movie.title
        cell.customImageView.setImage(PJCConfigurationAPI.shared.url(forImageFile: movie.backdropPath),
                                      placeholder: self.placeholder.next())
    }
}

// MARK: - PJCViewModelProvider
extension PJCMovieDataSourceSection: PJCViewModelProvider
{
    func viewModel(forObjectAt index: Int) -> PJCMovieViewModel?
    {
        guard let result = self.objects[index] as PJCMovie? else
        { return nil }
        
        return PJCMovieViewModel(model: result)
    }
}

