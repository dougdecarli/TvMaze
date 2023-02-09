//
//  FavoriteRouter.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import UIKit

protocol FavoriteRouterProtocol {
    
}

class FavoriteRouter: FavoriteRouterProtocol {
    private let navigationController: UINavigationController,
                favoriteStoryboard = UIStoryboard(name: "Favorites", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
