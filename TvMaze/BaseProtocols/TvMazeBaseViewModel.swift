//
//  TvMazeBaseViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import RxCocoa
import RxSwift

class TvMazeBaseViewModel<Router>: TvMazeViewModelProtocol {
    var disposeBag = DisposeBag(),
        router: Router,
        service: TvMazeServiceProtocol
    
    init(router: Router,
         service: TvMazeServiceProtocol) {
        self.router = router
        self.service = service
    }
    
    open func setupBindings() {}
    
    open func cleanBindings() {
        disposeBag = DisposeBag()
    }
}
