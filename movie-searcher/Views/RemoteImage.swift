//
//  RemoteImage.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//


import SwiftUI

struct RemoteImage: View {
    let url: URL
    @State private var imageData: Data?

    var body: some View {
        Group {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .onAppear {
                        NetworkManager.shared.fetchImage(from: url) { data in
                            self.imageData = data
                        }
                    }
            }
        }
    }
}
