//
//  MovieDetailView.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    
    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(imdbID: movie.id))
    }

    var body: some View {
        VStack {
            if let movie = viewModel.movie {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .center, spacing: 8) {
                            RemoteImage(url: movie.poster)
                                .frame(width: 200, height: 300)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                            
                            HStack {
                                Text(movie.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                                
                                Button(action: {
                                    favoritesManager.toggleFavorite(movie)
                                }) {
                                    Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                        .font(.title2)
                                }
                                .padding(.trailing, 10)
                            }
                            
                            Text("Year: \(movie.year)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        
                        GroupBox(label: Text("About").font(.headline).textCase(.uppercase)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(movie.plot ?? "No plot available.")")
                                Text("Genre: \(movie.genre ?? "N/A")")
                            }
                            .font(.body)
                            .multilineTextAlignment(.leading)
                        }
                        
                        GroupBox(label: Text("Cast & Crew").font(.headline).textCase(.uppercase)) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Director: \(movie.director ?? "N/A")")
                                Text("Writer: \(movie.writers ?? "N/A")")
                                Text("Actors: \(movie.actors ?? "N/A")")
                            }
                            .font(.body)
                        }
                        
                        GroupBox(label: Text("Details").font(.headline).textCase(.uppercase)) {
                            VStack(alignment: .leading, spacing: 6) {
                                if let ratings = movie.ratings, let rating = ratings.first {
                                    Text("Rating: \(rating.source) - \(rating.value)")
                                }
                                Text("Runtime: \(movie.runtime ?? "N/A")")
                                Text("Language: \(movie.language ?? "N/A")")
                                Text("IMDb Rating: \(movie.rating ?? "0") (\(movie.votes ?? "0") votes)")
                            }
                            .font(.body)
                        }
                    }
                    .padding()
                }
                .navigationTitle(movie.title)
                .navigationBarTitleDisplayMode(.inline)
                
            } else if viewModel.isLoading {
                VStack {
                    ProgressView("Fetching movie details...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                    Text("Oops! Something went wrong.")
                        .font(.headline)
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchMovieDetails()
        }
    }
}
