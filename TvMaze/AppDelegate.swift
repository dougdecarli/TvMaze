//
//  AppDelegate.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        TvMazeStarter.startFlow(window: window)
        window?.makeKeyAndVisible()
        window?.tintColor = .systemRed
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .dark
        }
        return true
    }
}

