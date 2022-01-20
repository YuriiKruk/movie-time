//
//  APICaller.swift
//  Movie Time
//
//  Created by Yury Kruk on 19.01.2022.
//

import Foundation

final class APICaller {
    
    /// Singleton
    static let shared = APICaller()
    
    private init() {}
    
    // MARK: - Constants
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
    
    // MARK: - Request
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
    /// Request to get the daily or weekly trending Movies or TV Shows.
    func getTrendingMovies(mediaType: MediaType, timeWindow: TimeWindow, completion: @escaping ((Result<MediaObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/trending" + mediaType.rawValue + timeWindow.rawValue + Constants.apiKey),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MediaObject.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Movie
    /// Request to get a list of movies in theatres.
    func getNowPlayingMovies(completion: @escaping ((Result<MediaObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/movie/now_playing" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MediaObject.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get the most newly created movie.
    /// - This is a live response and will continuously change.
    func getTopRatedMovies(completion: @escaping ((Result<MediaObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/movie/top_rated" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MediaObject.self, from: data)
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
