//
//  NetworkManager.swift
//  movie-searcher
//
//  Created by Eduardo Hoyos on 8/05/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private let session: URLSession

    private init() {
        let cache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                             diskCapacity: 100 * 1024 * 1024,
                             diskPath: "networkCache")

        let config = URLSessionConfiguration.default
        config.urlCache = cache
        config.requestCachePolicy = .useProtocolCachePolicy

        self.session = URLSession(configuration: config)
    }

    func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(Constants.baseURL)&s=\(encodedQuery)&page=\(page)") else {
            return completion(.failure(URLError(.badURL)))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(URLError(.badServerResponse)))
            }

            do {
                let result = try JSONDecoder().decode(MovieResponse.self, from: data)
                
                if result.response.lowercased() == "true" {
                    completion(.success(result.movies ?? []))
                } else {
                    let errorMessage = result.error ?? "Unknown error from server"
                    completion(.failure(NSError(domain: "MovieSearch", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<Movie, Error>) -> Void) {
        
        let urlString = "\(Constants.baseURL)&i=\(imdbID)&plot=full"

        guard let url = URL(string: urlString) else {
            return completion(.failure(URLError(.badURL)))
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(URLError(.badServerResponse)))
            }

            do {
                let result = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func fetchImage(from url: URL, completion: @escaping (Data?) -> Void) {
        let request = URLRequest(url: url)

        if let cachedResponse = session.configuration.urlCache?.cachedResponse(for: request) {
            completion(cachedResponse.data)
            return
        }

        session.dataTask(with: request) { data, response, _ in
            if let data = data, let response = response {
                let cached = CachedURLResponse(response: response, data: data)
                self.session.configuration.urlCache?.storeCachedResponse(cached, for: request)
            }

            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
