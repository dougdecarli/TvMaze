//
//  FavoritesViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import RxSwift
import RxCocoa

class FavoritesViewModel: TvMazeBaseViewModel<FavoriteRouterProtocol> {
    //MARK: Properties
    let onViewWillAppear = PublishRelay<Void>()
    var tvShowCells = PublishRelay<[ShowModel]>()
    
    private let favoriteManager: FavoritesUserDefaultsManager
    
    init(router: FavoriteRouterProtocol,
                  favoriteManager: FavoritesUserDefaultsManager = FavoritesUserDefaultsManager.shared) {
        self.favoriteManager = favoriteManager
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
    }
    
    //MARK: Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.getFavorites()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func getFavorites() {
        let favorites = favoriteManager.getAllFavoriteShows()
        tvShowCells.accept(favorites.sorted { $0.name < $1.name })
    }
}
