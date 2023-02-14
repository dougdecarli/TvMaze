//
//  RequestFactory.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import Foundation

class RequestFactory {
    enum Requests {
        case getPagedShows(page: Int)
        case getEpisodes(showId: Int)
        case searchShows(search: String)
        case getPeople(name: String)
        case getShowsByPerson(personId: Int)
    }
    
    static func buildGetPagedShowsRequest(page: Int) -> GetPagedShowsRequest {
        .init(page: page)
    }
    
    static func buildGetEpisodesRequest(showId: Int) -> GetEpisodesRequest {
        .init(showId: showId)
    }
    
    static func buildSearchShowsRequest(search: String) -> SearchTvShowsRequest {
        .init(search: search)
    }
    
    static func buildGetPeopleRequest(name: String) -> GetPeopleRequest {
        .init(name: name)
    }
    
    static func buildGetShowsByPersonRequest(personId: Int) -> GetShowsByPersonRequest {
        .init(personId: personId)
    }
    
    static func build(request: Requests) -> ServiceRequest {
        switch request {
        case .getPagedShows(let page):
            return buildGetPagedShowsRequest(page: page)
        case .getEpisodes(let showId):
            return buildGetEpisodesRequest(showId: showId)
        case .searchShows(let search):
            return buildSearchShowsRequest(search: search)
        case .getPeople(let name):
            return buildGetPeopleRequest(name: name)
        case .getShowsByPerson(let personId):
            return buildGetShowsByPersonRequest(personId: personId)
        }
    }
}
