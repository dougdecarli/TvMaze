//
//  GetShowsByPersonRequest.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
//

import Foundation

struct GetShowsByPersonRequest: ServiceRequest {
    var endpoint: String
    
    init(personId: Int) {
        self.endpoint = "people/\(personId)/castcredits?embed=show"
    }
}
