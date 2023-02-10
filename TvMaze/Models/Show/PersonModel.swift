//
//  TvMazeShowModel.swift
//  TvMaze
//
//  Created by Douglas Immig on 06/02/23.
//

import Foundation
import Differentiator

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

extension Person {
    static func mockArray() -> [Self] {
        [.init(id: 1, name: "", image: .init(medium: "", original: "")),
         .init(id: 1, name: "", image: .init(medium: "", original: "")),
         .init(id: 1, name: "", image: .init(medium: "", original: "")),
         .init(id: 1, name: "", image: .init(medium: "", original: "")),
         .init(id: 1, name: "", image: .init(medium: "", original: "")),
         .init(id: 1, name: "", image: .init(medium: "", original: ""))]
    }
}
