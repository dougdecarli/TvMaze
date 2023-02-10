//
//  FavoriteRouterMock.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import RxSwift
import RxCocoa

class FavoriteRouterMock: FavoriteRouterProtocol {
    var showsRouter: ShowsRouterProtocol
    
    public init(showsRouter: ShowsRouterProtocol) {
        self.showsRouter = showsRouter
    }
}
