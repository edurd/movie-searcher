//
//  FavoritesManager.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//

import SwiftUI

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    private let key = "FAVORITE_MOVIES"

    @Published var favorites: [Movie] = []

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: key),
           let movies = try? JSONDecoder().decode([Movie].self, from: data) {
            self.favorites = movies
        }
    }

    func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains(movie)
    }

    func toggleFavorite(_ movie: Movie) {
        if let index = favorites.firstIndex(of: movie) {
            favorites.remove(at: index)
        } else {
            favorites.append(movie)
        }
        saveFavorites()
    }
}
