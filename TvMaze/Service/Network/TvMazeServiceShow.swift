//
//  TvMazeService.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

class BaseTvMazeService {
    var API_URL: String {
        get {
            return "http://api.tvmaze.com"
        }
    }
}

enum Endpoints: String {
    case getShows = "/shows?page="
    case getEpisodes = "/shows"
    case searchTvShows = "/search/shows?q="
    case peopleSearch = "/search/people?q="
    case peopleShows = "/people/"
}

enum ServiceErrors: Error {
    case notFound
    case defaultError
    
    init(statusCode: Int) {
        switch statusCode {
        case 404:
            self = .notFound
        default:
            self = .defaultError
        }
    }
}

protocol TvMazeShowServiceProtocol {
    func getShows(page: Int) -> Observable<[ShowModel]>
    func getEpisodes(from showId: Int) -> Observable<[Episode]>
    func searchTvShows(search: String) -> Observable<[ShowModel]>
    func cancelAllTasks()
}

class TvMazeShowService: BaseTvMazeService, TvMazeShowServiceProtocol {
    private var task: URLSessionTask?
    
    func getShows(page: Int) -> Observable<[ShowModel]> {
        guard let url = URL(string: "\(API_URL)\(Endpoints.getShows.rawValue)\(page)") else {
            return Observable<[ShowModel]>.error(ServiceErrors.defaultError)
        }
        
        return Observable<[ShowModel]>.create { [weak self] (observable) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    observable.onError(ServiceErrors.notFound)
                }
                
                if let jsonData = data {
                    do {
                        let shows = try JSONDecoder().decode(Array<ShowModel>.self, from: jsonData)
                        observable.onNext(shows)
                    } catch {
                        observable.onError(ServiceErrors.defaultError)
                    }
                }
                observable.onCompleted()
            }
            self.task?.resume()
            return Disposables.create{}
        }
    }
    
    func getEpisodes(from showId: Int) -> Observable<[Episode]> {
        guard let url = URL(string: "\(API_URL)\(Endpoints.getEpisodes.rawValue)/\(showId)/episodes") else {
            return Observable<[Episode]>.error(ServiceErrors.defaultError)
        }
        
        return Observable<[Episode]>.create { [weak self] (observable) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    observable.onError(ServiceErrors.notFound)
                }
                
                if let jsonData = data {
                    do {
                        let episodes = try JSONDecoder().decode(Array<Episode>.self, from: jsonData)
                        observable.onNext(episodes)
                    } catch {
                        observable.onError(ServiceErrors.defaultError)
                    }
                }
                observable.onCompleted()
            }
            self.task?.resume()
            return Disposables.create{}
        }
    }
    
    func searchTvShows(search: String) -> Observable<[ShowModel]> {
        guard let url = URL(string: ("\(API_URL)\(Endpoints.searchTvShows.rawValue)\(search.replacingOccurrences(of: " ", with: "%20"))"))
        else {
            return Observable<[ShowModel]>.just([ShowModel]())
        }
        
        return Observable<[ShowModel]>.create { [weak self] (observable) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    observable.onNext([ShowModel]())
                }
                
                if let jsonData = data {
                    do {
                        let searchModel = try JSONDecoder().decode(Array<SearchedShow>.self, from: jsonData)
                        observable.onNext(searchModel.map { $0.show })
                    } catch {
                        observable.onNext([ShowModel]())
                    }
                }
                observable.onCompleted()
            }
            self.task?.resume()
            return Disposables.create{}
        }
    }
    
    func cancelAllTasks() {
        task?.cancel()
    }
}

protocol TvMazePeopleServiceProtocol {
    func getPeople(by name: String) -> Observable<[Person]>
    func getShowsByPerson(personId: Int) -> Observable<[ShowModel]>
}

class TvMazePeopleService: BaseTvMazeService, TvMazePeopleServiceProtocol {
    private var task: URLSessionTask?
    
    func getPeople(by name: String) -> Observable<[Person]> {
        guard let url = URL(string: ("\(API_URL)\(Endpoints.peopleSearch.rawValue)\(name.replacingOccurrences(of: " ", with: "%20"))"))
        else {
            return Observable<[Person]>.just([Person]())
        }
        
        return Observable<[Person]>.create { [weak self] (observable) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    observable.onError(ServiceErrors.notFound)
                }
                
                if let jsonData = data {
                    do {
                        let people = try JSONDecoder().decode(Array<SearchedPerson>.self, from: jsonData)
                        observable.onNext(people.map { $0.person })
                    } catch {
                        observable.onError(ServiceErrors.defaultError)
                    }
                }
                observable.onCompleted()
            }
            self.task?.resume()
            return Disposables.create{}
        }
    }
    
    func getShowsByPerson(personId: Int) -> Observable<[ShowModel]> {
        guard let url = URL(string: "\(API_URL)\(Endpoints.peopleShows.rawValue)\(personId)/castcredits?embed=show") else {
            return Observable<[ShowModel]>.error(ServiceErrors.defaultError)
        }
        
        return Observable<[ShowModel]>.create { [weak self] (observable) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    observable.onNext([ShowModel]())
                }
                
                if let jsonData = data {
                    do {
                        let personShows = try JSONDecoder().decode(Array<CastResult>.self, from: jsonData)
                        observable.onNext(personShows.map { $0.embedded.show })
                    } catch {
                        observable.onNext([ShowModel]())
                    }
                }
                observable.onCompleted()
            }
            self.task?.resume()
            return Disposables.create{}
        }
    }
}
