//
//  EpisodeDetailViewModelTests.swift
//  TvMazeTests
//
//  Created by Douglas Immig on 09/02/23.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import TvMaze

class EpisodeDetailViewModelTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag(),
        scheduler: TestScheduler = TestScheduler(initialClock: .zero),
        router: ShowsRouterMock = ShowsRouterMock(),
        episode: Episode = Episode.mockArray().first!
    
    lazy var service: TvMazeServiceProtocol = TvMazeServiceMock(behavior: [],
                                                                scheduler: scheduler)
    lazy var viewModel = EpisodeDetailViewModel(router: router,
                                                episode: episode)
    
    override func setUp() {
        super.setUp()
        
        viewModel.setupBindings()
    }
    
    func testEpisodeDependecies() {
        XCTAssertEqual(viewModel.episode, episode)
    }
}
