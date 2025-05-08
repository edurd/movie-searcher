//
//  MovieListViewModel.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//

import Foundation
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var currentPage = 1
    private var currentQuery = ""
    private var isFetchingMore = false

    func fetchMovies(query: String? = nil, page: Int = 1) {
        isLoading = true
        currentQuery = query ?? ""
        currentPage = page

        NetworkManager.shared.searchMovies(query: currentQuery, page: page) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let newMovies):
                    self.showError = false
                    if page == 1 {
                        self.movies = newMovies
                    } else {
                        self.movies.append(contentsOf: newMovies)
                    }
                case .failure(let error):
                    self.movies = []
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func fetchNextPageIfNeeded(currentMovie movie: Movie) {
        guard !isFetchingMore,
              let lastMovie = movies.last,
              lastMovie.id == movie.id else { return }

        isFetchingMore = true
        fetchMovies(query: currentQuery, page: currentPage + 1)
        currentPage += 1
        isFetchingMore = false
    }
}
