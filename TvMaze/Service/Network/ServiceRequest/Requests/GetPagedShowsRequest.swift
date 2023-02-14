//
//  GetPagedShowsRequest.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import Foundation

struct GetPagedShowsRequest: ServiceRequest {
    var endpoint: String
    
    init(page: Int) {
        self.endpoint = "shows?page=\(page)"
    }
}
