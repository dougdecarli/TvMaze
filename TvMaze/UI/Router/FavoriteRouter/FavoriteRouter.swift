//
//  FavoriteRouter.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import UIKit

protocol FavoriteRouterProtocol {
    var showsRouter: ShowsRouterProtocol { get set }
}

class FavoriteRouter: FavoriteRouterProtocol {
    private let navigationController: UINavigationController,
                favoriteStoryboard = UIStoryboard(name: "Favorites", bundle: nil)
    
    var showsRouter: ShowsRouterProtocol
    
    init(showsRouter: ShowsRouterProtocol,
         navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.showsRouter = showsRouter
    }
}
