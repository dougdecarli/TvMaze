//
//  EpisodeDetailViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 07/02/23.
//

import Foundation
import RxSwift
import RxCocoa

final class EpisodeDetailViewModel: TvMazeBaseViewModel<ShowsRouterProtocol> {
    //MARK: Properties
    let episode: Episode
    
    init(router: ShowsRouterProtocol,
         episode: Episode) {
        self.episode = episode
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
    }
}
