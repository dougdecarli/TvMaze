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
    private let service: TvMazeShowServiceProtocol,
                scheduler: SchedulerType,
                cellItemsRelay = BehaviorRelay<[ShowModel]>(value: [])
    
    var isLoaderShowing = PublishSubject<Bool>(),
        currentPage = 1,
        isFetchingData = BehaviorRelay<Bool>(value: false)
    
    //MARK: Pagination
    let tableViewDidScrollToBottom = PublishSubject<Void>()
    
    //MARK: Input Properties
    let onViewDidLoad = PublishRelay<Void>(),
        onTvShowSelected = PublishRelay<ShowModel>(),
        searchBarTextField = BehaviorRelay(value: "")
    
    //MARK: Output Properties
    var isTableViewHiddenDriver: Driver<Bool> {
        .just(false)
    }
    
    var tvShowCells: Observable<[ShowModel]> {
        setupTvShowCells(searchBarTextField.asObservable(), tableViewDidScrollToBottom)
    }
    
    init(router: ShowsRouterProtocol,
         service: TvMazeShowServiceProtocol,
         scheduler: SchedulerType = MainScheduler.instance) {
        self.service = service
        self.scheduler = scheduler
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnTvShowSelected()
        
        tvShowCells
            .bind(to: cellItemsRelay)
            .disposed(by: disposeBag)
    }
    
    //MARK: Input
    private func setupOnTvShowSelected() {
        onTvShowSelected
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.router.goToTvShowDetail(tvShow: model, service: self.service)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupTvShowCells(_ textFieldString: Observable<String>,
                                  _ didScrollToBottom: Observable<Void>) -> Observable<[ShowModel]> {
        let searching = textFieldString
            .debounce(.milliseconds(500), scheduler: scheduler)
            .filter { $0.count > 0 }
            .debug("searching...")
            .flatMapLatest(service.searchTvShows)
        
        let notSearching = textFieldString
                .debounce(.milliseconds(500), scheduler: scheduler)
                .filter { $0.count == 0 }
                .map { _ in Int(1) }
                .flatMapLatest(service.getShows(page:))
        
        let didScrollToBottom = didScrollToBottom
            .debounce(.milliseconds(500), scheduler: scheduler)
            .map { [weak self] _ -> Int in
                guard let self = self else { return 1 }
                self.currentPage += 1
                return self.currentPage
            }
            .do(onNext: { [weak self] _ in
                self?.isFetchingData.accept(true)
            })
            .debug("DEBUG search:")
            .flatMapLatest(service.getShows(page:))
            .do(onNext: { [weak self] _ in
                self?.isFetchingData.accept(false)
            })
//            .withLatestFrom(cellItemsRelay) { (newShows, currentShows) in (newShows, currentShows) }
//            .scan([ShowModel]()) { (accumulatedValues, showValues) in
//                return showValues
//            }
        
        return Observable.merge(searching, notSearching, didScrollToBottom)
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
