//
//  TvMazeStarter.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import UIKit

class TvMazeStarter {
    static func startFlow(window: UIWindow?) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBar")
        window?.rootViewController = tabBar
    }
}
