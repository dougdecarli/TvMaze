//
//  TvMazeLoadableViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import RxSwift

protocol TvMazeLoadableViewModel {
    var isLoaderShowing: PublishSubject<Bool> { get }
}

extension TvMazeLoadableViewModel {
    func startLoader() {
        isLoaderShowing.onNext(true)
    }
    
    func stopLoader() {
        isLoaderShowing.onNext(false)
    }
}
