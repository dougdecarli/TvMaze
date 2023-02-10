//
//  TvShowDetailViewModelTests.swift
//  TvMazeTests
//
//  Created by Douglas Immig on 09/02/23.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import TvMaze

class TvShowDetailViewModelTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag(),
        scheduler: TestScheduler = TestScheduler(initialClock: .zero),
        router: ShowsRouterMock = ShowsRouterMock()
    
    lazy var service: TvMazeServiceProtocol = TvMazeServiceMock(behavior: [],
                                                                scheduler: scheduler)
    lazy var viewModel = TvShowDetailViewModel(router: router,
                                               service: service,
                                               tvShowModel: ShowModel.mock())
    
    override func setUp() {
        super.setUp()
        
        viewModel.setupBindings()
    }
    
    func testOnGetEpisodesSuccess() {
        let numberOfCellsLoadedObserver = scheduler.createObserver(Int.self)
        
        _ = scheduler.createHotObservable([.next(10, ())])
            .bind(to: viewModel.onViewWillAppear)
            .disposed(by: disposeBag)
        
        viewModel
            .showDetailCells
            .map { $0.count }
            .compactMap { $0 }
            .bind(to: numberOfCellsLoadedObserver)
            .disposed(by: disposeBag)
        
        ///Header + episodes
        let expectedNumberOfCells = 1 + Episode.mockArray().count
        
        scheduler.start()
        
        XCTAssertEqual(numberOfCellsLoadedObserver.events, [
            .next(0, 0),
            .next(10, 1),
            .next(15, 2),
            .next(15, 3),
            .next(15, 4),
            .next(15, 5),
            .next(15, 6),
            .next(15, expectedNumberOfCells),
        ])
    }
    
    func testOnGetEpisodesError() {
        ///Setting getEpisodes endpoint error behavior
        let service = TvMazeServiceMock(behavior: [.getEpisodesError], scheduler: scheduler)
        viewModel = TvShowDetailViewModel(router: router,
                                          service: service,
                                          tvShowModel: ShowModel.mock())
        viewModel.setupBindings()
        
        _ = scheduler.createHotObservable([.next(10, ())])
            .bind(to: viewModel.onViewWillAppear)
            .disposed(by: disposeBag)
        
        let numberOfCellsLoadedObserver = scheduler.createObserver(Int.self)
        
        viewModel
            .showDetailCells
            .map { $0.count }
            .compactMap { $0 }
            .bind(to: numberOfCellsLoadedObserver)
            .disposed(by: disposeBag)
        
        ///cells count must be one - only header
        let expectedNumberOfCells = 1
        
        scheduler.start()
        
        XCTAssertEqual(numberOfCellsLoadedObserver.events, [
            .next(0, 0),
            .next(10, expectedNumberOfCells)
        ])
    }
    
    func testOnEpisodeSelected() {
        let routerObservable = scheduler.createObserver(ShowsRouterMock.Transition.self)
        
        let episodeSelected = ShowDetailCellsDataSource.episodes(model: Episode.mockArray().first!)
        _ = scheduler.createHotObservable([.next(10, episodeSelected)])
            .bind(to: viewModel.onEpisodeSelected)
            .disposed(by: disposeBag)
        
        router.transitions
            .compactMap { $0 }
            .bind(to: routerObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(routerObservable.events, [.next(10, .goToEpisodeDetail)])
    }
}
