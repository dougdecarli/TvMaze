//
//  TvMazeServiceMock.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import RxSwift
import RxCocoa

enum TvMazeServiceBehaviorMock: String {
    case getShowsError = "getShowsError"
    case getEpisodesError = "getEpisodesError"
    case searchTvShowsError = "searchTvShows"
    case getPeopleError = "getPeopleError"
    case getShowsByPersonError = "getShowsByPersonError"
}

class TvMazeServiceMock: TvMazeServiceProtocol {
    let behaviors: [TvMazeServiceBehaviorMock]
    var scheduler: SchedulerType
    let delay: RxTimeInterval
    
    public init(behavior: [TvMazeServiceBehaviorMock],
                scheduler: SchedulerType = MainScheduler.instance,
                delay: RxTimeInterval = .seconds(5)) {
        self.behaviors = behavior
        self.scheduler = scheduler
        self.delay = delay
    }
    
    func getShows(page: Int) -> Observable<[ShowModel]> {
        if has(.getShowsError) {
            if scheduler is MainScheduler {
                return mainSchedulerError()
            } else {
                return .just([])
            }
        } else {
            return .just(ShowModel.mockArray())
                .delay(delay, scheduler: scheduler)
        }
    }
    
    func getEpisodes(from showId: Int) -> Observable<[Episode]> {
        if has(.getEpisodesError) {
            if scheduler is MainScheduler {
                return mainSchedulerError()
            } else {
                return .error(ServiceErrors.defaultError)
            }
        } else {
            return .just(Episode.mockArray())
                .delay(delay, scheduler: scheduler)
        }
    }
    
    func searchTvShows(search: String) -> Observable<[ShowModel]> {
        if has(.searchTvShowsError) {
            if scheduler is MainScheduler {
                return mainSchedulerError()
            } else {
                return .error(ServiceErrors.defaultError)
            }
        } else {
            return .just([])
                .delay(delay, scheduler: scheduler)
        }
    }
    
    func getPeople(by name: String) -> Observable<[Person]> {
        if has(.getPeopleError) {
            if scheduler is MainScheduler {
                return mainSchedulerError()
            } else {
                return .just([])
            }
        } else {
            return .just(Person.mockArray())
                .delay(delay, scheduler: scheduler)
        }
    }
    
    func getShowsByPerson(personId: Int) -> Observable<[ShowModel]> {
        if has(.getShowsByPersonError) {
            if scheduler is MainScheduler {
                return mainSchedulerError()
            } else {
                return .just([])
            }
        } else {
            return .just(ShowModel.mockArray())
                .delay(delay, scheduler: scheduler)
        }
    }
    
    private func has(_ behavior: TvMazeServiceBehaviorMock) -> Bool {
        behaviors.contains { behavior == $0 }
    }
    
    private func mainSchedulerError<T>() -> Observable<T> {
        Observable.create { observer in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                observer.onError(ServiceErrors.defaultError)
            }
            return Disposables.create()
        }
    }
}
