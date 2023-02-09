//
//  TvShowDetailViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 07/02/23.
//

import RxSwift
import RxCocoa

class TvShowDetailViewModel: TvMazeBaseViewModel<ShowsRouterProtocol> {
    //MARK: Properties
    private let tvShowModel: ShowModel,
                service: TvMazeServiceProtocol
    
    private let episodesSeasonSection = BehaviorRelay<[ShowDetailsSectionModel]>(value: [])
    
    let onViewWillAppear = PublishRelay<Void>(),
        onEpisodeSelected = PublishRelay<ShowDetailCellsDataSource>()
    
    var isLoaderShowing = PublishSubject<Bool>()
    var episodeSeasonCells: Observable<[ShowDetailsSectionModel]> {
        episodesSeasonSection.asObservable()
    }
    
    init(router: ShowsRouterProtocol,
         service: TvMazeServiceProtocol,
         tvShowModel: ShowModel) {
        self.tvShowModel = tvShowModel
        self.service = service
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
        setupOnEpisodeSelected()
    }
    
    //MARK: Input
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: { [weak self] in
//                self?.startLoader()
                self?.addHeaderCell()
            })
            .subscribe(onNext: { [weak self] in
                self?.getEpisodes()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupOnEpisodeSelected() {
        onEpisodeSelected
            .subscribe { [weak self] cellSelected in
                switch cellSelected {
                case .episodes(let model):
                    self?.router.goToEpisodeDetail(episode: model)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: Service
    private func getEpisodes() {
        service.getEpisodes(from: tvShowModel.id)
            .subscribe(onNext: { [weak self] episodes in
                guard let self = self else { return }
                self.stopLoader()
                let seasonsByEpisode = self.resolveEpisodesCells(episodes)
                seasonsByEpisode.forEach({ (season, episodes) in
                    self.episodesSeasonSection.accept(self.episodesSeasonSection.value + [.init(model: "Season \(season)",
                                                                                                items: self.retrieveEpisodesDataSource(episodes: episodes))])
                })
            }, onError: { [weak self] _ in
                self?.stopLoader()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Helper methods
    private func addHeaderCell() {
        episodesSeasonSection.accept([.init(model: "", items: [.header(model: tvShowModel)])])
    }
    
    private func resolveEpisodesCells(_ episodes: [Episode]) -> [Int: [Episode]] {
        var episodesBySeason: [Int: [Episode]] = [:]
        let seasons = Set(episodes.map { $0.season })
        seasons.forEach { episodesBySeason[$0] = [] }
        episodes.forEach { episodesBySeason[$0.season]?.append($0) }
        return episodesBySeason
    }
    
    func retrieveEpisodesDataSource(episodes: [Episode]) -> [ShowDetailCellsDataSource] {
        var dataSource: [ShowDetailCellsDataSource] = []
        episodes.forEach { episode in
            dataSource.append(.episodes(model: episode))
        }
        return dataSource
    }
}

extension TvShowDetailViewModel: TvMazeLoadableViewModel {}
