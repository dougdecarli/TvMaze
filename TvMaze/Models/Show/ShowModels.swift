//
//  ShowModels.swift
//  TvMaze
//
//  Created by Douglas Immig on 09/02/23.
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

//MARK: Mocks
extension ShowModel {
    static func mock() -> Self {
        .init(id: 1, name: "Name", schedule: .init(time: "", days: [""]), genres: [""])
    }
    
    static func mockArray() -> [Self] {
        [.init(id: 1, name: "Name", schedule: .init(time: "", days: [""]), genres: [""]),
         .init(id: 1, name: "Name", schedule: .init(time: "", days: [""]), genres: [""]),
         .init(id: 1, name: "Name", schedule: .init(time: "", days: [""]), genres: [""]),
         .init(id: 1, name: "Name", schedule: .init(time: "", days: [""]), genres: [""]),
         .init(id: 1, name: "Name", schedule: .init(time: "", days: [""]), genres: [""])]
    }
}

extension Episode {
    static func mockArray() -> [Self] {
        [.init(id: 1, name: "", number: 1, season: 2, summary: "", image: .init(medium: "", original: "")),
         .init(id: 2, name: "", number: 1, season: 1, summary: "", image: .init(medium: "", original: "")),
         .init(id: 3, name: "", number: 1, season: 3, summary: "", image: .init(medium: "", original: "")),
         .init(id: 4, name: "", number: 1, season: 4, summary: "", image: .init(medium: "", original: "")),
         .init(id: 5, name: "", number: 1, season: 5, summary: "", image: .init(medium: "", original: "")),
         .init(id: 6, name: "", number: 1, season: 6, summary: "", image: .init(medium: "", original: ""))]
    }
}
