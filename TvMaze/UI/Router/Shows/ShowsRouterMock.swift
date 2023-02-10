//
//  ShowsRouterMock.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import RxSwift
import RxCocoa

class ShowsRouterMock: ShowsRouterProtocol {
    public var transitions = PublishSubject<Transition>()
    
    public init() {}
    
    public enum Transition: Equatable {
        case goToTvShowDetail
        case goToEpisodeDetail
        
        public static func == (lhs: Transition,
                               rhs: Transition) -> Bool {
            switch (lhs, rhs) {
            case (.goToTvShowDetail, .goToTvShowDetail),
                (.goToEpisodeDetail, goToEpisodeDetail):
                return true
            default:
                return false
            }
        }
    }
    
    func goToTvShowDetail(tvShow: ShowModel, service: TvMazeServiceProtocol) {
        transitions.onNext(.goToTvShowDetail)
    }
    
    func goToEpisodeDetail(episode: Episode) {
        transitions.onNext(.goToEpisodeDetail)
    }
}
