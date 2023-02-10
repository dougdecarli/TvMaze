//
//  PersonDetailViewModelTests.swift
//  TvMazeTests
//
//  Created by Douglas Immig on 09/02/23.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import TvMaze

class PersonDetailViewModelTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag(),
        scheduler: TestScheduler = TestScheduler(initialClock: .zero),
        showsRouter = ShowsRouterMock(),
        person = Person.mockArray().first!
    
    lazy var router: PeopleRouterMock = PeopleRouterMock(showsRouter: showsRouter)
    lazy var service: TvMazeServiceProtocol = TvMazeServiceMock(behavior: [],
                                                                scheduler: scheduler)
    lazy var viewModel = PersonDetailViewModel(router: router,
                                               person: person,
                                               service: service)
    
    override func setUp() {
        super.setUp()
        
        viewModel.setupBindings()
    }
    
    func testShowsCastingByPerson() {
        let numberOfCellsLoadedObserver = scheduler.createObserver(Int.self)
        
        viewModel
            .tvShowCells
            .map { $0.count }
            .compactMap { $0 }
            .bind(to: numberOfCellsLoadedObserver)
            .disposed(by: disposeBag)
        
        let expectedNumberOfCells = ShowModel.mockArray().count
        
        scheduler.start()
        
        XCTAssertEqual(numberOfCellsLoadedObserver.events, [
            .next(5, expectedNumberOfCells),
            .completed(6)
        ])
    }
    
    func testOnShowSelected() {
        let routerObservable = scheduler.createObserver(ShowsRouterMock.Transition.self)
        
        let showSelected = ShowModel.mockArray().first!
        _ = scheduler.createHotObservable([.next(10, showSelected)])
            .bind(to: viewModel.onPersonTouched)
            .disposed(by: disposeBag)
        
        showsRouter.transitions
            .compactMap { $0 }
            .bind(to: routerObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(routerObservable.events, [.next(10, .goToTvShowDetail)])
    }
}
