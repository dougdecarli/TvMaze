//
//  TvMazeTabBarController.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import UIKit
import RxSwift
import RxCocoa

final class TvMazeTabBarController: UITabBarController {
    private var service: TvMazeServiceProtocol = TvMazeService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataInjection()
    }
    
    private func setupDataInjection() {
        guard let viewControllers = viewControllers else {
            return
        }

        for viewController in viewControllers {
            if let navBar = viewController as? UINavigationController {
                if let showsVC = navBar.topViewController as? TvMazeShowListViewController {
                    loadShowsVC(showsVC)
                } else if let peopleVC = navBar.topViewController as? PeopleListViewController {
                    loadPeopleVC(peopleVC)
                } else if let favoriteVC = navBar.topViewController as? FavoritesViewController {
                    loadFavoriteVC(favoriteVC)
                }
            }
        }
    }
    
    private func loadShowsVC(_ showsVC: TvMazeShowListViewController) {
        let router = ShowsRouter(navigationController: showsVC.navigationController ?? UINavigationController())
        let viewModel = TvMazeShowListViewModel(router: router, service: service)
        showsVC.viewModel = viewModel
    }
    
    private func loadPeopleVC(_ peopleVC: PeopleListViewController) {
        let router = PeopleRouter(navigationController: peopleVC.navigationController ?? UINavigationController(),
                                  showsRouter: ShowsRouter(navigationController: peopleVC.navigationController ?? UINavigationController()))
        let viewModel = PeopleListViewModel(router: router, service: service)
        peopleVC.viewModel = viewModel
    }
    
    private func loadFavoriteVC(_ favoriteVC: FavoritesViewController) {
        let router = FavoriteRouter(showsRouter: ShowsRouter(navigationController: favoriteVC.navigationController ?? UINavigationController()),
                                    navigationController: favoriteVC.navigationController ?? UINavigationController())
        let viewModel = FavoritesViewModel(router: router, service: service)
        favoriteVC.viewModel = viewModel
    }
}
