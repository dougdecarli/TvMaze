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
    private var tvShows = BehaviorRelay<[ShowModel]>(value: []),
                pageCounter = 1,
                maxValue = 250,
                isPaginationRequestStillResume = false,
                isRefreshRequstStillResume = false
    var isLoaderShowing = PublishSubject<Bool>()
    
    //MARK: Input Properties
    let onViewDidLoad = PublishRelay<Void>(),
        tableViewDidScrollToBottom = PublishSubject<Void>(),
        tableViewDidRefreshed = PublishSubject<Void>(),
        refreshControlCompleted = PublishSubject<Void>(),
        isLoadingSpinnerAvailable = PublishSubject<Bool>(),
        isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    
    //MARK: Output Properties
    var tvShowCells: BehaviorRelay<[ShowModel]> {
        tvShows
    }
    
    init(router: ShowsRouterProtocol,
         service: TvMazeShowServiceProtocol) {
        self.service = service
        super.init(router: router)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewDidLoad()
        onTableViewDidScroolToBottom()
        onTableViewDidRefreshed()
    }
    
    //MARK: Input
    private func setupOnViewDidLoad() {
        onViewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.getShows(self.pageCounter)
            })
            .disposed(by: disposeBag)
    }
    
    private func onTableViewDidScroolToBottom() {
        tableViewDidScrollToBottom
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.fetchData(page: self.pageCounter,
                                isRefreshControl: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func onTableViewDidRefreshed() {
        tableViewDidRefreshed
            .subscribe(onNext: { [weak self] in
                self?.refreshControlTriggered()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Service
    private func getShows(_ page: Int) {
        service
            .getShows(page: page)
            .do(onNext: { [weak self] _ in
                self?.startLoading()
            })
            .subscribe(onNext: { [weak self] shows in
                self?.stopLoading()
                self?.resolveResponse(shows)
                self?.isLoadingSpinnerAvaliable.onNext(false)
                self?.isPaginationRequestStillResume = false
                self?.isRefreshRequstStillResume = false
                self?.refreshControlCompleted.onNext(())
            }, onError: { [weak self] error in
                print("ERROR")
                self?.stopLoading()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Navigation
    
    //MARK: - Helper methods
    private func resolveResponse(_ shows: [ShowModel]) {
        if pageCounter == 1 {
            tvShows.accept(shows)
        } else {
            let oldData = tvShows.value
            tvShows.accept(oldData + shows)
        }
        pageCounter += 1
    }
    
    private func fetchData(page: Int, isRefreshControl: Bool) {
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        isRefreshRequstStillResume = isRefreshControl
        
        if pageCounter > maxValue  {
            isPaginationRequestStillResume = false
            return
        }
       
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 1 || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }
        
        getShows(pageCounter)
    }
    
    private func refreshControlTriggered() {
        service.cancelAllTasks()
        isPaginationRequestStillResume = false
        pageCounter = 1
        tvShows.accept([])
        fetchData(page: pageCounter, isRefreshControl: true)
    }
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}

extension TvMazeShowListViewModel: TvMazeLoadableViewModel {}
