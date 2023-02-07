//
//  TvMazeShowModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation

struct ShowModel: Decodable {
    var id: Int
    var name: String
    var url: URL?
    var schedule: Schedule
    var genres: [String]
    var summary: String?
    var image: ShowImage
}

struct Schedule: Decodable {
    var time: String
    var days: [String]
}

struct ShowImage: Decodable {
    let medium: String
    let original: String
}

struct Episode: Decodable {
    public var id: Int
    public var name: String
    public var number: Int
    public var season: Int
    public var summary: String?
    public var image: URL?
}
