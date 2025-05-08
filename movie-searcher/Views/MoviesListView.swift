//
//  MoviesListView.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Loading...")
                        .padding()
                } else if !viewModel.movies.isEmpty {
                    List(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieRow(movie: movie)
                        }
                        .onAppear {
                            viewModel.fetchNextPageIfNeeded(currentMovie: movie)
                        }
                    }
                } else if viewModel.showError, let error = viewModel.errorMessage {
                    Text("⚠️ \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("Start typing to search for movies.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Movies")
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) {
                viewModel.fetchMovies(query: viewModel.searchText)
            }
            .onAppear {
                if viewModel.movies.isEmpty {
                    viewModel.fetchMovies(query: "Avengers")
                }
            }
        }
    }
}
