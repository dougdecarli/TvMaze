//
//  FavoritesViewModelTests.swift
//  TvMazeTests
//
//  Created by Douglas Immig on 09/02/23.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import TvMaze

class FavoritesViewModelTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag(),
        scheduler: TestScheduler = TestScheduler(initialClock: .zero),
        showsRouter = ShowsRouterMock()
    
    lazy var router: FavoriteRouterMock = FavoriteRouterMock(showsRouter: showsRouter)
    lazy var service: TvMazeServiceProtocol = TvMazeServiceMock(behavior: [],
                                                                scheduler: scheduler)
    lazy var viewModel = FavoritesViewModel(router: router,
                                            service: service,
                                            favoriteManager: FavoritesUserDefaultsManagerMock())
    
    override func setUp() {
        super.setUp()
        
        viewModel.setupBindings()
    }
    
    func testOnGetFavorites() {
        let numberOfCellsLoadedObserver = scheduler.createObserver(Int.self)
        
        _ = scheduler.createHotObservable([.next(10, ())])
            .bind(to: viewModel.onViewWillAppear)
            .disposed(by: disposeBag)
        
        viewModel
            .tvShowCells
            .map { $0.count }
            .compactMap { $0 }
            .bind(to: numberOfCellsLoadedObserver)
            .disposed(by: disposeBag)
        
        let expectedNumberOfCells = ShowModel.mockArray().count
        
        scheduler.start()
        
        XCTAssertEqual(numberOfCellsLoadedObserver.events, [
            .next(10, expectedNumberOfCells)
        ])
    }
    
    func testOnShowSelected() {
        let routerObservable = scheduler.createObserver(ShowsRouterMock.Transition.self)
        
        let favoriteSelected = ShowModel.mockArray().first!
        _ = scheduler.createHotObservable([.next(10, favoriteSelected)])
            .bind(to: viewModel.onFavoriteTouched)
            .disposed(by: disposeBag)
        
        showsRouter.transitions
            .compactMap { $0 }
            .bind(to: routerObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(routerObservable.events, [.next(10, .goToTvShowDetail)])
    }
}
