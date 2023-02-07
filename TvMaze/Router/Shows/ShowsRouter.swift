//
//  ShowsRouter.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import UIKit

protocol ShowsRouterProtocol {
    
}

class ShowsRouter: ShowsRouterProtocol {
    private let navigationController: UINavigationController,
                showsStoryboard = UIStoryboard(name: "Shows", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
