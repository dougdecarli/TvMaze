//
//  GetEpisodesRequest.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import Foundation

struct GetEpisodesRequest: ServiceRequest {
    var endpoint: String
    
    init(showId: Int) {
        self.endpoint = "\(showId)/episodes"
    }
}
