//
//  GetPeopleRequest.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import Foundation

struct GetPeopleRequest: ServiceRequest {
    var endpoint: String
    
    init(name: String) {
        self.endpoint = "search/people?q=\(name.replacingOccurrences(of: " ", with: "%20"))"
    }
}
