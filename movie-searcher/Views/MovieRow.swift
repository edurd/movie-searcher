//
//  MovieRow.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//

import SwiftUI

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 16) {
            RemoteImage(url: movie.poster)
                .frame(width: 60, height: 90)
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)

                Text("Year: \(movie.year)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(movie.type.capitalized)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

