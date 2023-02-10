//
//  ShowListViewModelsTests.swift
//  TvMazeTests
//
//  Created by Douglas Immig on 09/02/23.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import TvMaze

class TvMazeShowListViewModelTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag(),
        scheduler: TestScheduler = TestScheduler(initialClock: .zero),
        router: ShowsRouterMock = ShowsRouterMock()
    
    lazy var service: TvMazeServiceProtocol = TvMazeServiceMock(behavior: [],
                                                                 scheduler: scheduler)
    lazy var viewModel = TvMazeShowListViewModel(router: router,
                                                 service: service,
                                                 scheduler: scheduler)
    
    override func setUp() {
        super.setUp()
        
        viewModel.setupBindings()
    }
    
    func testOnLoadShowCells() {
        let numberOfCellsLoadedObserver = scheduler.createObserver(Int.self)
        viewModel.searchBarTextField.accept("")
        viewModel
            .tvShowCells
            .map { $0.count }
            .compactMap { $0 }
            .bind(to: numberOfCellsLoadedObserver)
            .disposed(by: disposeBag)
        
        let expectedNumberOfCells = ShowModel.mockArray().count
        
        scheduler.start()
        
        XCTAssertEqual(numberOfCellsLoadedObserver.events, [
            .next(0, 0),
            .next(6, expectedNumberOfCells)
        ])
    }
    
    func testOnGetShowsError() {
        ///Setting getShows endpoint error behavior
        let service = TvMazeServiceMock(behavior: [.getShowsError], scheduler: scheduler)
        viewModel = TvMazeShowListViewModel(router: router, service: service, scheduler: scheduler)
        viewModel.setupBindings()
        
        let numberOfCellsLoadedObserver = scheduler.createObserver(Int.self)
        
        viewModel
            .tvShowCells
            .map { $0.count }
            .compactMap { $0 }
            .bind(to: numberOfCellsLoadedObserver)
            .disposed(by: disposeBag)
        
        ///cells count must be zero
        let expectedNumberOfCells = 0
        
        scheduler.start()
        
        XCTAssertEqual(numberOfCellsLoadedObserver.events, [
            .next(0, 0),
            .next(1, expectedNumberOfCells)
        ])
    }
    
    func testOnShowSelected() {
        let routerObservable = scheduler.createObserver(ShowsRouterMock.Transition.self)
        
        let showSelected = ShowModel.mock()
        _ = scheduler.createHotObservable([.next(10, showSelected)])
            .bind(to: viewModel.onTvShowSelected)
            .disposed(by: disposeBag)
        
        router.transitions
            .compactMap { $0 }
            .bind(to: routerObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(routerObservable.events, [.next(10, .goToTvShowDetail)])
    }
}
