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
    private var tvShowModel: ShowModel,
                service: TvMazeServiceProtocol,
                seasonCounter = 1
    
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
                self.resolveEpisodesCells(episodes)
            }, onError: { [weak self] _ in
                self?.stopLoader()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Helper methods
    private func addHeaderCell() {
        episodesSeasonSection.accept([.init(model: "", items: [.header(model: tvShowModel)])])
    }
    
    private func resolveEpisodesCells(_ episodes: [Episode]) {
        var episodesBySeason: [Int: [Episode]] = [:]
        episodes.forEach { episode in
            if episodesBySeason[episode.season] == nil {
                episodesBySeason[episode.season] = [episode]
            } else {
                episodesBySeason[episode.season]?.append(episode)
            }
        }
        let sortedSeasons = episodesBySeason.keys.sorted()
        seasonCounter = 1
        sortedSeasons.forEach({ season in
            episodesSeasonSection.accept(episodesSeasonSection.value + [.init(model: "Season \(seasonCounter)", items: retrieveEpisodesDataSource(episodes: episodesBySeason[seasonCounter]!))])
            seasonCounter += 1
        })
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
