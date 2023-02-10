//
//  FavoritesUserDefaultsManager.swift
//  TvMaze
//
//  Created by Douglas Immig on 08/02/23.
//

import Foundation

enum UserDefaultsKeys: String {
    case favorites = "favorites"
}

protocol FavoritesUserDefaultsManagerProtocol {
    func addFavorite(tvShow: ShowModel)
    func saveShows(_ shows: [ShowModel])
    func getAllFavoriteShows() -> [ShowModel]
    func getFavorite(withId id: Int) -> ShowModel?
    func removeFavorite(withId id: Int)
}

class FavoritesUserDefaultsManager: FavoritesUserDefaultsManagerProtocol {
    static let shared = FavoritesUserDefaultsManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    func addFavorite(tvShow: ShowModel) {
        var shows = getAllFavoriteShows()
        shows.append(tvShow)
        saveShows(shows)
    }
    
    func saveShows(_ shows: [ShowModel]) {
        do {
            let data = try JSONEncoder().encode(shows)
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: UserDefaultsKeys.favorites.rawValue)
            defaults.synchronize()
        } catch {
            print(error)
        }
    }
    
    func getAllFavoriteShows() -> [ShowModel] {
        if let data = userDefaults.object(forKey: UserDefaultsKeys.favorites.rawValue) as? Data {
            do {
                let shows = try JSONDecoder().decode([ShowModel].self, from: data)
                return shows
            } catch {
                return []
            }
        } else {
            return []
        }
    }
    
    func getFavorite(withId id: Int) -> ShowModel? {
        let shows = getAllFavoriteShows()
        if shows.count > 0 {
            let show = shows.first(where: { $0.id == id })
            return show
        } else {
            return nil
        }
    }
    
    func removeFavorite(withId id: Int) {
        var shows = getAllFavoriteShows()
        if shows.count > 0 {
            shows = shows.filter({ $0.id != id })
            do {
                let data = try JSONEncoder().encode(shows)
                let defaults = UserDefaults.standard
                defaults.set(data, forKey: UserDefaultsKeys.favorites.rawValue)
                defaults.synchronize()
            } catch {
                print(error)
            }
        }
    }
}

class FavoritesUserDefaultsManagerMock: FavoritesUserDefaultsManagerProtocol {
    func addFavorite(tvShow: ShowModel) {}
    
    func saveShows(_ shows: [ShowModel]) {}
    
    func getAllFavoriteShows() -> [ShowModel] {
        ShowModel.mockArray()
    }
    
    func getFavorite(withId id: Int) -> ShowModel? {
        ShowModel.mockArray().first!
    }
    
    func removeFavorite(withId id: Int) {}
}
