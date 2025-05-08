//
//  movie_searcherApp.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 7/05/25.
//

import SwiftUI

@main
struct movie_searcherApp: App {
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            MovieListView()
                .environmentObject(favoritesManager)
        }
    }
}
