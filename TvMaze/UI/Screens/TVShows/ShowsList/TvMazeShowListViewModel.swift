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
    private let service: TvMazeServiceProtocol,
                scheduler: SchedulerType,
                cellItemsRelay = BehaviorRelay<[ShowModel]>(value: [])
    
    var isLoaderShowing = PublishSubject<Bool>(),
        currentPage = 1,
        isFetchingData = BehaviorRelay<Bool>(value: false)
    
    //MARK: Pagination
    let tableViewDidScrollToBottom = PublishSubject<Void>(),
        onFavoriteButtonTouched = PublishRelay<ShowModel>()
    
    //MARK: Input Properties
    let onViewDidLoad = PublishRelay<Void>(),
        onTvShowSelected = PublishRelay<ShowModel>(),
        searchBarTextField = BehaviorRelay(value: "")
    
    //MARK: Output Properties
    var isTableViewHiddenDriver: Driver<Bool> {
        .just(false)
    }
    
    var tvShowCells = BehaviorRelay<[ShowModel]>(value: [])
    
    init(router: ShowsRouterProtocol,
         service: TvMazeServiceProtocol,
         scheduler: SchedulerType = MainScheduler.instance) {
        self.service = service
        self.scheduler = scheduler
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnTvShowSelected()
        setupTvShowCells(searchBarTextField.asObservable(),
                         tableViewDidScrollToBottom.asObservable())
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
                                  _ didScrollToBottom: Observable<Void>) {
        let searching = textFieldString
            .debounce(.milliseconds(500), scheduler: scheduler)
            .filter { $0.count > 0 }
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
            .flatMapLatest(service.getShows(page:))
            .do(onNext: { [weak self] _ in
                self?.isFetchingData.accept(false)
            })
        
        let sideEvents = Observable.merge(notSearching, didScrollToBottom)
            .scan(tvShowCells.value) { (accumulatedValues, showValues) in
                return accumulatedValues + showValues
            }
                
        Observable.merge(sideEvents, searching)
            .bind(to: tvShowCells)
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
