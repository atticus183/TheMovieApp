//
//  Networking.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import UIKit

final class TMDbManager {

    let apiKey = TMdbAPIKey.KEY

    private let baseURL = "https://api.themoviedb.org/3/"
    static let imgBaseURL = "https://image.tmdb.org/t/p/"

    enum TMDbErr: Error {
        case badURL
        case badResponse(Int)
        case failureToDecodeJSON

        var errorMessage: String {
            switch self {
            case .badURL:
                return "Bad url supplied."
            case .badResponse(let respCode):
                return "HTTP Error code \(respCode)."
            case .failureToDecodeJSON:
                return "There was an error decoding the JSON."
            }
        }
    }

    func tmdbRequest<T: Codable>(_ type: T.Type, endPoint: EndPoint, completion: @escaping (Result<T, TMDbErr>) -> Void) {
        //Create URL string
        let urlString = baseURL + endPoint.path + "?api_key=\(apiKey)&language=en-US"

        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if let _ = error {
                completion(.failure(.badURL))
            }

            if let response = response as? HTTPURLResponse {
                if 400...499 ~= response.statusCode {
                    completion(.failure(.badResponse(response.statusCode)))
                    return
                }
            }

            if let data = data {
                //MARK: Decode JSON
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                do {
                    let decodedJSON = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(decodedJSON))
                } catch {
                    completion(.failure(.failureToDecodeJSON))
                }
            }
        }.resume()
    }

    //API - https://developers.themoviedb.org/3/search/search-movies
    func searchForMovie(with searchText: String, completion: @escaping (Result<MovieSearchResults, TMDbErr>) -> Void) {
        let cleanedSearchText = searchText.lowercased().replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(cleanedSearchText)&page=1&include_adult=false")

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let _ = error {
                completion(.failure(.badURL))
            }

            if let response = response as? HTTPURLResponse {
                if 400...499 ~= response.statusCode {
                    completion(.failure(.badResponse(response.statusCode)))
                    return
                }
            }

            if let data = data {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let decodedJSON = try jsonDecoder.decode(MovieSearchResults.self, from: data)
                    completion(.success(decodedJSON))
                } catch {
                    completion(.failure(.failureToDecodeJSON))
                }
            }
        }.resume()
    }

    enum EndPoint {
        case getDetails(String)
        case getReleaseDates(String)
        case getLatest
        case getNowPlaying
        case getPopular
        case getTopRated
        case getUpcoming

        var path: String {
            switch self {
            case .getDetails(let id):
                return "movie/\(id)"
            case .getReleaseDates(let id):
                return "movie/\(id)/release_dates"
            case .getLatest:
                return "movie/latest"
            case .getNowPlaying:
                return "movie/now_playing"
            case .getPopular:
                return "movie/popular"
            case .getTopRated:
                return "movie/top_rated"
            case .getUpcoming:
                return "movie/upcoming"
            }
        }
    }

    //MARK: Generate image url string
    //Kingfisher takes a string
    enum ImgSize: String  {
        case backdropW300
        case backdropW780
        case backdropW1280
        case backdropOriginal

        case logoW45
        case logoW92
        case logoW154
        case logoW185
        case logoW300
        case logoW500
        case logoOriginal

        case posterW92
        case posterW154
        case posterW342
        case posterW500
        case posterW780
        case posterOriginal

        var sizeString: String {
            switch self {
            case .backdropW300:
                return "w300"
            case .backdropW780:
                return "w780"
            case .backdropW1280:
                return "w1280"
            case .backdropOriginal:
                return "original"
            case .logoW45:
                return "w45"
            case .logoW92:
                return "w92"
            case .logoW154:
                return "w154"
            case .logoW185:
                return "w185"
            case .logoW300:
                return "w300"
            case .logoW500:
                return "w500"
            case .logoOriginal:
                return "original"
            case .posterW92:
                return "w92"
            case .posterW154:
                return "w154"
            case .posterW342:
                return "w342"
            case .posterW500:
                return "w500"
            case .posterW780:
                return "w780"
            case .posterOriginal:
                return "original"
            }
        }
    }
}
