//
//  PJCPersonDataSourceSection.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 13/04/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


fileprivate typealias CellType = PJCPersonTableViewCell

class PJCPersonDataSourceSection: PJCDataSourceSection<PJCPerson>
{
    // MARK: - Property(s)
    
    private(set) lazy var api: PJCSearchAPIRequestDelegate =
    {
        let configuration = URLSessionConfiguration.named("com.movies-db.cache.search.person")
        let session = URLSession(configuration: configuration)
        let service = PJCDataService(session: session)
        
        return PJCSearchAPI(service)
    }()
    
    private(set) var search: PJCAPISearch<PJCPerson>?
}

// MARK: - PJCDataSourceSectionRegister
extension PJCPersonDataSourceSection: PJCDataSourceSectionRegister
{
    var cellClass: AnyClass?
    { return CellType.self }
}

// MARK: - PJCDataSourceSectionPresenter
extension PJCPersonDataSourceSection: PJCDataSourceSectionPresenter
{
    func cell(_ cell: UIView,
              displayObjectAt index: Int)
    {
        guard let cell = cell as? CellType,
            let viewModel = self.viewModel(forObjectAt: index) else
        { return }

        cell.textLabel?.text = viewModel.name.showbizz() + " • " + viewModel.knownForDepartment
        cell.utilityLabel.text = viewModel.knownFor
        cell.customImageView.setImage(viewModel.profileUrl,
                                      placeholder: viewModel.placeholderImage())
    }
}

// MARK: - PJCDataSourceSelectDelegate
extension PJCPersonDataSourceSection: PJCDataSourceSelectDelegate
{
    func dataSource(_ dataSource: PJCDataSource,
                    didSelectRowAt index: Int)
    {
        guard let _ = UIApplication.shared.rootViewController,
            let viewModel = self.viewModel(forObjectAt: index) else
        { return }                              
        
        print("""
            \(viewModel.name.showbizz())
            \(viewModel.knownForDepartment)
            \(viewModel.knownFor)
            
            """)
    }
}

// MARK: - PJCViewModelProvider
extension PJCPersonDataSourceSection: PJCViewModelProvider
{
    func viewModel(forObjectAt index: Int) -> PJCPersonViewModel?
    {
        guard let result = self.objects[index] as PJCPerson? else
        { return nil }
        
        return PJCPersonViewModel(model: result)
    }
}

// MARK: - PJCDataSourcePrefetchDelegate
extension PJCPersonDataSourceSection: PJCDataSourcePrefetchDelegate
{
    func dataSource(_ dataSource: PJCDataSource,
                    prefetchRowsAt indexPath: IndexPath,
                    completion: @escaping PJCDataSourcePrefetchHandler)
    {
        guard let dataSource = dataSource as? PJCSearchDataSource else
        {
            completion(.failure(PJCServiceError.notFound))
            return
        }
        
        let handler: PJCAPISearchResponseHandler<PJCPerson> =
        { (result) in
            
            guard let search = try? result.get().objects.first,
                let results = search.results as [PJCPerson]? else
            {
                completion(.failure(PJCServiceError.notFound))
                return
            }
            
            self.search = search
            
            // TODO:Support PJCPersonDataStore.shared.insert ...
            
            self.objects.append(contentsOf: results)
            
            let start: Int = self.numberOfObjects() - results.count
            let end: Int = start + (results.count - 1)
            let section = indexPath.isEmpty ? 0 : indexPath.section
            let indexPaths = (start...end).map { IndexPath(item: $0, section: section) }
            
            completion(.success(indexPaths))
        }
        
        let queryItems = PJCSearchAPI.pagedQueryItems(dataSource.queryItems,
                                                      with: self.search)
        
        let request = PJCGenericAPIRequest(PJCPerson.self,
                                          queryItems: queryItems)
        
        self.api.request(request, completion: handler)
    }
}

