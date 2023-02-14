//
//  SearchTvShowsRequest.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import Foundation

struct SearchTvShowsRequest: ServiceRequest {
    var endpoint: String
    
    init(search: String) {
        self.endpoint = "search/shows?q=\(search.replacingOccurrences(of: " ", with: "%20"))"
    }
}
