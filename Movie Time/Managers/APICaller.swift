//
//  APICaller.swift
//  Movie Time
//
//  Created by Yury Kruk on 19.01.2022.
//

struct Constants {
    static let baseAPIURL = "https://api.themoviedb.org/3"
    static let apiKey = "?api_key=c5115d2fd4b5c7908af39275bad3df28"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
}

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    enum APIError: Error {
        case failedToGetData
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum MediaType: String {
        case all = "/all"
        case movie = "/movie"
        case tv = "/tv"
        case person = "/person"
    }
    
    enum TimeWindow: String {
        case day = "/day"
        case week = "/week"
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        guard let apiURL = url else {
            return
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        completion(request)
    }
    
    // MARK: - Trending
    func getTrendingMovie(mediaType: MediaType, timeWindow: TimeWindow, completion: @escaping ((Result<Trending, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/trending" + mediaType.rawValue + timeWindow.rawValue + Constants.apiKey),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Trending.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
