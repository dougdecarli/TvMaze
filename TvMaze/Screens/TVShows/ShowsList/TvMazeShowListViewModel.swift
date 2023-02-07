//
//  TvMazeShowListViewModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import RxSwift
import RxCocoa

final class TvMazeShowListViewModel: TvMazeBaseViewModel<ShowsRouterProtocol> {
    //MARK: Properties
    private let service: TvMazeShowServiceProtocol
    private var tvShows = BehaviorRelay<[ShowModel]>(value: [])
    var isLoaderShowing = PublishSubject<Bool>()
    
    //MARK: Input Properties
    let onViewDidLoad = PublishRelay<Void>()
    
    //MARK: Output Properties
    var tvShowCells: Observable<[ShowModel]> {
        setupTvShowCells()
    }
    
    init(router: ShowsRouterProtocol,
         service: TvMazeShowServiceProtocol) {
        self.service = service
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewDidLoad()
    }
    
    //MARK: Input
    private func setupOnViewDidLoad() {
        onViewDidLoad
            .do(onNext: { [weak self] in
                self?.startLoading()
            })
            .subscribe(onNext: { [weak self] in
                self?.getShows()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Output
    private func setupTvShowCells() -> Observable<[ShowModel]> {
        tvShows.asObservable()
    }
    
    //MARK: Service
    private func getShows() {
        service
            .getShows(page: 1)
            .subscribe(onNext: { [weak self] shows in
                self?.tvShows.accept(shows)
                self?.stopLoading()
            }, onError: { [weak self] error in
                print("ERROR")
                self?.stopLoading()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Navigation
    
    //MARK: - Helper methods
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}

extension TvMazeShowListViewModel: TvMazeLoadableViewModel {}
