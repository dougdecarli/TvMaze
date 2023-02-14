//
//  TvMazeService.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import RxSwift
import RxCocoa

protocol TvMazeServiceProtocol {
    func getShows(page: Int) -> Observable<[ShowModel]>
    func getEpisodes(from showId: Int) -> Observable<[Episode]>
    func searchTvShows(search: String) -> Observable<[ShowModel]>
    func getPeople(by name: String) -> Observable<[Person]>
    func getShowsByPerson(personId: Int) -> Observable<[ShowModel]>
}

class TvMazeService: TvMazeBaseService, TvMazeServiceProtocol {
    func getShows(page: Int) -> Observable<[ShowModel]> {
        request(RequestFactory.build(request: .getPagedShows(page: page)),
                responseType: [ShowModel].self)
    }
    
    func getEpisodes(from showId: Int) -> Observable<[Episode]> {
        request(RequestFactory.build(request: .getEpisodes(showId: showId)),
                responseType: [Episode].self)
    }
    
    func searchTvShows(search: String) -> Observable<[ShowModel]> {
        request(RequestFactory.buildSearchShowsRequest(search: search),
                responseType: [ShowModel].self)
    }
    
    func getPeople(by name: String) -> Observable<[Person]> {
        request(RequestFactory.buildGetPeopleRequest(name: name),
                responseType: [Person].self)
    }
    
    func getShowsByPerson(personId: Int) -> Observable<[ShowModel]> {
        request(RequestFactory.buildGetShowsByPersonRequest(personId: personId),
                responseType: [ShowModel].self)
    }
}
