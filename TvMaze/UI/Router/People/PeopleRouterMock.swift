//
//  PeopleRouterMock.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import RxSwift
import RxCocoa

class PeopleRouterMock: PeopleRouterProtocol {
    var showsRouter: ShowsRouterProtocol
    public var transitions = PublishSubject<Transition>()
    
    public init(showsRouter: ShowsRouterProtocol) {
        self.showsRouter = showsRouter
    }
    
    public enum Transition: Equatable {
        case goToPersonDetail
        
        public static func == (lhs: Transition,
                               rhs: Transition) -> Bool {
            switch (lhs, rhs) {
            case (.goToPersonDetail, .goToPersonDetail):
                return true
            }
        }
    }
    
    func goToPersonDetail(person: Person, service: TvMazeServiceProtocol) {
        transitions.onNext(.goToPersonDetail)
    }
}

