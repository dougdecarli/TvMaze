//
//  PeopleListViewModelTests.swift
//  TvMazeTests
//
//  Created by Douglas Immig on 09/02/23.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import TvMaze

class PeopleListViewModelTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag(),
        scheduler: TestScheduler = TestScheduler(initialClock: .zero),
        router: PeopleRouterMock = PeopleRouterMock(showsRouter: ShowsRouterMock())
    
    lazy var service: TvMazeServiceProtocol = TvMazeServiceMock(behavior: [],
                                                                scheduler: scheduler)
    lazy var viewModel = PeopleListViewModel(router: router,
                                             service: service)
    
    override func setUp() {
        super.setUp()
        
        viewModel.setupBindings()
    }
    
    func testOnLoadPeopleAfterSearchCells() {
        let numberOfCellsLoadedObserver = scheduler.createObserver(Int.self)
        viewModel.searchBarTextField.accept("Str")
        
        viewModel
            .peopleCells
            .map { $0.count }
            .compactMap { $0 }
            .bind(to: numberOfCellsLoadedObserver)
            .disposed(by: disposeBag)
        
        let expectedNumberOfCells = Person.mockArray().count
        
        scheduler.start()
        
        XCTAssertEqual(numberOfCellsLoadedObserver.events, [
            .next(5, expectedNumberOfCells)
        ])
    }
    
    func testOnLoadPeopleErrorCells() {
        ///Setting loadPeople endpoint error behavior
        let service = TvMazeServiceMock(behavior: [.getPeopleError], scheduler: scheduler)
        viewModel = PeopleListViewModel(router: router,
                                        service: service)
        viewModel.setupBindings()
        viewModel.searchBarTextField.accept("Str")
        
        let numberOfCellsLoadedObserver = scheduler.createObserver(Int.self)
        
        viewModel
            .peopleCells
            .map { $0.count }
            .compactMap { $0 }
            .bind(to: numberOfCellsLoadedObserver)
            .disposed(by: disposeBag)
        
        ///cells count must be zero
        let expectedNumberOfCells = 0
        
        scheduler.start()
        
        XCTAssertEqual(numberOfCellsLoadedObserver.events, [
            .next(0, expectedNumberOfCells)
        ])
    }
    
    func testOnPersonSelected() {
        let routerObservable = scheduler.createObserver(PeopleRouterMock.Transition.self)
        
        let personSelected = Person.mockArray().first!
        _ = scheduler.createHotObservable([.next(10, personSelected)])
            .bind(to: viewModel.onPersonSelected)
            .disposed(by: disposeBag)
        
        router.transitions
            .compactMap { $0 }
            .bind(to: routerObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(routerObservable.events, [.next(10, .goToPersonDetail)])
    }
}
