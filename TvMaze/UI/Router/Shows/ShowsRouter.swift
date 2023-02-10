//
//  ShowsRouter.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import UIKit

protocol ShowsRouterProtocol {
    func goToTvShowDetail(tvShow: ShowModel, service: TvMazeServiceProtocol)
    func goToEpisodeDetail(episode: Episode)
}

class ShowsRouter: ShowsRouterProtocol {
    private let navigationController: UINavigationController,
                showsStoryboard = UIStoryboard(name: "Shows", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func goToTvShowDetail(tvShow: ShowModel, service: TvMazeServiceProtocol) {
        guard let vc = showsStoryboard.instantiateViewController(withIdentifier: "tvShowDetail") as? TvShowDetailViewController else { return }
        vc.viewModel = TvShowDetailViewModel(router: self,
                                             service: service,
                                             tvShowModel: tvShow)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToEpisodeDetail(episode: Episode) {
        guard let vc = showsStoryboard.instantiateViewController(withIdentifier: "episodeDetail") as? EpisodeDetailViewController else { return }
        vc.viewModel = EpisodeDetailViewModel(router: self, episode: episode)
        navigationController.pushViewController(vc, animated: true)
    }
}


