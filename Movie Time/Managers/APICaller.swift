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
    func getTrendingMovies(mediaType: MediaType, timeWindow: TimeWindow, completion: @escaping ((Result<MovieObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/trending" + mediaType.rawValue + timeWindow.rawValue + Constants.apiKey),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MovieObject.self, from: data)
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
    func getNowPlayingMovies(completion: @escaping ((Result<MovieObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/movie/now_playing" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MovieObject.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get the top rated movies..
    func getTopRatedMovies(completion: @escaping ((Result<MovieObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/movie/top_rated" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MovieObject.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get the most popular movies.
    func getPopularMovies(completion: @escaping ((Result<MovieObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/movie/popular" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MovieObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get the upcoming movies.
    func getUpcomingMovies(page: Int = 1, completion: @escaping ((Result<MovieObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/movie/upcoming" + Constants.apiKey + "&language=en-US&page=" + String(page) + "&region=US"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(MovieObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get a list of recommended movies for a movie id.
    func getRecommendedMovies(movieID id: String, completion: @escaping ((Result<MovieObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/movie/" + id + "/recommendations" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MovieObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get a list of similar movies.
    /// - These items are assembled by looking at keywords and genres.
    func getSimilarMovies(movieID id: String, completion: @escaping ((Result<MovieObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/movie/" + id + "/similar" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MovieObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - TV Shows
    
    /// Request to get the current popular TV Shows.
    func getPopularTVShows(completion: @escaping ((Result<TVShowObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/tv/popular" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(TVShowObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get a list of recommended TV shows for a TV id.
    func getRecommendedTVShows(tvShowID id: String, completion: @escaping ((Result<TVShowObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/tv/" + id + "/recommendations" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(TVShowObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get a list of similar TV shows. These items are assembled by looking at keywords and genres.
    func getSimilarTVShows(tvShowID id: String, completion: @escaping ((Result<TVShowObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/tv/" + id + "/similar" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(TVShowObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    /// Request to get a list of shows that are currently on the air.
    /// - This query looks for any TV show that has an episode with an air date in the next 7 days.
    func getOnTheAirTVShows(completion: @escaping ((Result<TVShowObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/tv/on_the_air" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(TVShowObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get a list of the top rated TV shows.
    func getTopRatedTVShows(completion: @escaping ((Result<TVShowObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/tv/top_rated" + Constants.apiKey), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(TVShowObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - People
    
    /// Request to get the list of popular people. This list updates daily.
    func getPopularPersons(completion: @escaping ((Result<PersonObject, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/person/popular" + Constants.apiKey + "&language=en-US"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PersonObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Search
    /// Search multiple models in a single request. Multi search currently supports searching for movies, tv shows and people in a single request.
    func getSearch(with query: String, completion: @escaping ((Result<[SearchResult], Error>) -> Void)) {
        let url = Constants.baseAPIURL + "/search/multi" + Constants.apiKey + "&language=en-US&query=" + query + "&include_adult=false"
        createRequest(
            with: URL(string: url),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                    var searchResult: [SearchResult] = []
                    
                    result.results.forEach { object in
                        switch object {
                        case .movie(let movie):
                            searchResult.append(.movie(models: movie))
                        case .tv(let tv):
                            searchResult.append(.tv(models: tv))
                        case .person(let person):
                            searchResult.append(.person(persons: person))
                        }
                    }
                    
                    completion(.success(searchResult))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Discover (only for genres)
    /// Request to get a list of movies by genre.
    func getMovieListByGenre(genre: Int, completion: @escaping ((Result<MovieObject, Error>) -> Void)) {
        let baseURL = Constants.baseAPIURL + "/discover/movie"
        let queryString = "&language=en-US&sort_by=popularity.asc&with_genres="
        let genreString = String(genre)
        createRequest(with: URL(string: baseURL + Constants.apiKey + queryString + genreString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(MovieObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    /// Request to get a list of TVShows by genre.
    func getTVShowsListByGenre(genre: Int, completion: @escaping ((Result<TVShowObject, Error>) -> Void)) {
        let baseURL = Constants.baseAPIURL + "/discover/tv"
        let genreString = String(genre)
        let queryString = "&language=en-US&sort_by=popularity.desc&with_genres=\(genreString)&include_null_first_air_dates=false"
        createRequest(with: URL(string: baseURL + Constants.apiKey + queryString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(TVShowObject.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
