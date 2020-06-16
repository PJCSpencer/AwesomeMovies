//
//  PJCTableViewDataSource.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 08/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCTableViewDataSource: PJCDataSource {}

// MARK: - PJCDataSourceRegistered
extension PJCTableViewDataSource: PJCDataSourceRegistered
{
    func register(_ dataView: UITableView)
    {
        dataView.dataSource = self
        dataView.delegate = self
        
        self.sections.forEach
        {
            if let nib = $0.nib
            { dataView.register(nib,
                                forCellReuseIdentifier: $0.reuseIdenifier) }
            else
            {
                dataView.register($0.cellClass ?? UITableViewCell.self,
                                  forCellReuseIdentifier: $0.reuseIdenifier)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PJCTableViewDataSource: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    { return self.sections.count }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        return self.section(at: section)?.numberOfObjects() ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {    
        let section = self.sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.reuseIdenifier,
                                                 for: indexPath)
        
        section.cell(cell, displayObjectAt: indexPath.row)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PJCTableViewDataSource: UITableViewDelegate {}

