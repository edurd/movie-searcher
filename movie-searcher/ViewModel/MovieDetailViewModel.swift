//
//  MovieDetailViewModel.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//

import SwiftUI

class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var imdbID: String

    init(imdbID: String) {
        self.imdbID = imdbID
    }

    func fetchMovieDetails() {
        isLoading = true
        NetworkManager.shared.fetchMovieDetails(imdbID: imdbID) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedMovie):
                    self.movie = fetchedMovie
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
