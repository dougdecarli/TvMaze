//
//  TvMazeShowModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import Differentiator

struct ShowModel: Codable {
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

struct SearchedShow: Codable {
    let score: Double
    let show: ShowModel
}

struct Schedule: Codable {
    var time: String
    var days: [String]
}

struct Image: Codable, Hashable, IdentifiableType, Equatable {
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

struct SearchedPerson: Decodable {
    let score: Double
    let person: Person
}

struct Person: Decodable {
    let id: Int
    let name: String
    let image: Image?
}

struct CastResult: Decodable {
    var links: CastLinks
    var embedded: CastEmbedded
    
    private enum CodingKeys : String, CodingKey {
        case links = "_links"
        case embedded = "_embedded"
    }
}

struct CastEmbedded: Decodable {
    var show: ShowModel
}

struct MazeURL: Codable {
    var href: String
}

struct CastLinks: Codable {
    var show: MazeURL?
    var character: MazeURL?
}
