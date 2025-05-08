//
//  Movie.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//

import Foundation

struct MovieResponse: Decodable {
    let movies: [Movie]?
    let totalResults: String?
    let response: String
    let error: String?

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}

struct Movie: Codable, Identifiable, Equatable {
    var id: String
    let title: String
    let year: String
    let poster: URL
    let type: String
    let genre: String?
    let director: String?
    let writers: String?
    let actors: String?
    let plot: String?
    let language: String?
    let rating: String?
    let runtime: String?
    let ratings: [Rating]?
    let votes: String?

    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case type = "Type"
        case genre = "Genre"
        case director = "Director"
        case writers = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case rating = "imdbRating"
        case runtime = "Runtime"
        case ratings = "Ratings"
        case votes = "imdbVotes"
    }
}
struct Rating: Codable, Equatable {
    let value: String
    let source: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
