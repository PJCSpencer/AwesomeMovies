//
//  PJCSceneDelegate.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


class PJCSceneDelegate: UIResponder, UIWindowSceneDelegate
{
    // MARK: - Property(s)
    
    var window: UIWindow?


    // MARK: - UIWindowSceneDelegate
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else
        { return }
        
        let sections: [PJCDataSourceSectionType] =
        [
            PJCMovieDataSourceSection([]),
            PJCPersonDataSourceSection([])
        ]
        
        let controller = PJCSearchViewController(nibName: nil, bundle: nil)
        controller.dataSource = PJCSearchDataSource(with: sections)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
    }
}

