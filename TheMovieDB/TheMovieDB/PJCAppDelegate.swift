//
//  PJCAppDelegate.swift
//  TheMovieDB
//
//  Created by Peter Spencer on 07/03/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import UIKit


@UIApplicationMain
class PJCAppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - Property(s)
    
    private(set) var dataStore: PJCCoreDataStore = PJCCoreDataStore()
    
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        PJCConfigurationAPI.shared.cache()
        
        return true
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

// MARK: - Utility
extension UIApplication
{
    var rootViewController: UIViewController?
    {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else
        { return nil }
        
        return window.rootViewController
    }
}

// MARK: - CoreData Support
extension UIApplication
{
    var dataStore: PJCCoreDataStore
    { return (UIApplication.shared.delegate as! PJCAppDelegate).dataStore }
}

