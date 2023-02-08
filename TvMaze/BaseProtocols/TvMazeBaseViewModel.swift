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
        router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    open func setupBindings() {}
    
    open func cleanBindings() {
        disposeBag = DisposeBag()
    }
}
