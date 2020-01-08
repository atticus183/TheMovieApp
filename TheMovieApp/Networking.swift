//
//  Networking.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation


enum DataError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case serverError
}


class JSONParser {
    typealias result<T> = (Result<T, Error>) -> Void
    
    func decodeSingle<T: Decodable>(of type: T.Type, from url: URL, completion: @escaping result<T>) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DataError.invalidResponse))
                return
            }
            
            if 200 ... 299 ~= response.statusCode {
                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        let decodedData = try jsonDecoder.decode(T.self, from: data)
                        completion(.success(decodedData))
                    }
                    catch {
                        completion(.failure(DataError.decodingError))
                    }
                } else {
                    completion(.failure(DataError.invalidData))
                }
            } else {
                completion(.failure(DataError.serverError))
            }
        }.resume()
    }
    
    typealias results<T> = (Result<[T], Error>) -> Void
    
    func decodeMultiple<T: Decodable>(of type: T.Type, from url: URL, completion: @escaping results<T>) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DataError.invalidResponse))
                return
            }
            
            if 200 ... 299 ~= response.statusCode {
                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        let decodedData = try jsonDecoder.decode([T].self, from: data)
                        completion(.success(decodedData))
                    }
                    catch {
                        completion(.failure(DataError.decodingError))
                    }
                } else {
                    completion(.failure(DataError.invalidData))
                }
            } else {
                completion(.failure(DataError.serverError))
            }
        }.resume()
    }
    
    //Download full movie details
    func decodeMovieDetails(with movieID: String, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let APIKey = TMdbAPIKey.KEY
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(APIKey)&language=en-US")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DataError.invalidResponse))
                return
            }
            
            if 200 ... 299 ~= response.statusCode {
                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        let decodedData = try jsonDecoder.decode(MovieDetails.self, from: data)
                        completion(.success(decodedData))
                    }
                    catch {
                        completion(.failure(DataError.decodingError))
                    }
                } else {
                    completion(.failure(DataError.invalidData))
                }
            } else {
                completion(.failure(DataError.serverError))
            }
        }.resume()
    }
    
    
    
}

struct MovieHelper {
    typealias ImgSize = String
    
    static func retrieveImg(path: String, withSize size: ImgSize) -> String {
        return "https://image.tmdb.org/t/p/\(size)\(path)"
    }
    
    static let backdropW300 = "w300"
    static let backdropW780 = "w780"
    static let backdropW1280 = "w1280"
    static let backdropOriginal = "original"
    
    static let logoW45 = "w45"
    static let logoW92 = "w92"
    static let logoW154 = "w154"
    static let logoW185 = "w185"
    static let logoW300 = "w300"
    static let logoW500 = "w500"
    static let logoOriginal = "original"
    
    static let posterW92 = "w92"
    static let posterW154 = "w154"
    static let posterW342 = "w342"
    static let posterW500 = "w500"
    static let posterW780 = "w780"
    static let posterOriginal = "original"
    
}

    
//    "logo_sizes": [
//      "w45",
//      "w92",
//      "w154",
//      "w185",
//      "w300",
//      "w500",
//      "original"
//    ],
//    "profile_sizes": [
//      "w45",
//      "w185",
//      "h632",
//      "original"
//    ],
//    "still_sizes": [
//      "w92",
//      "w185",
//      "w300",
//      "original"
//    ]

