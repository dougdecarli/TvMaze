//
//  TvMazeShowModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import Differentiator

struct ShowModel: Decodable {
    var id: Int
    var name: String
    var url: URL?
    var schedule: Schedule
    var genres: [String]
    var summary: String?
    var image: Image?
//    var episodesBySeason: [Int: [Episode]] = [:]
//    var seasonKeys: [Int] {
//        episodesBySeason.keys.sorted()
//    }
}

struct SearchedShow: Decodable {
    let score: Double
    let show: ShowModel
}

struct Schedule: Decodable {
    var time: String
    var days: [String]
}

struct Image: Decodable, Hashable, IdentifiableType, Equatable {
    let medium: String
    let original: String
    
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
}

struct Episode: Decodable, Hashable, IdentifiableType, Equatable {
    let id: Int
    let name: String
    let number: Int
    let season: Int
    let summary: String?
    let image: Image?
    
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
}

struct Season: Decodable {
    let season: Int
    let episodes: [Episode]
}
