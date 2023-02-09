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
    let onViewWillAppear = PublishRelay<Void>(),
        onFavoriteTouched = PublishRelay<ShowModel>()
    var tvShowCells = PublishRelay<[ShowModel]>()
    
    private let favoriteManager: FavoritesUserDefaultsManager,
                service: TvMazeServiceProtocol
    
    init(router: FavoriteRouterProtocol,
         service: TvMazeServiceProtocol,
         favoriteManager: FavoritesUserDefaultsManager = FavoritesUserDefaultsManager.shared) {
        self.favoriteManager = favoriteManager
        self.service = service
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
        setupOnFavoriteTouched()
    }
    
    //MARK: Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.getFavorites()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupOnFavoriteTouched() {
        onFavoriteTouched
            .subscribe(onNext: { [weak self] fav in
                guard let self = self else { return }
                self.router.showsRouter.goToTvShowDetail(tvShow: fav, service: self.service)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func getFavorites() {
        let favorites = favoriteManager.getAllFavoriteShows()
        tvShowCells.accept(favorites.sorted { $0.name < $1.name })
    }
}
