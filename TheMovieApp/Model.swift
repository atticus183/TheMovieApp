//
//  Model.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation

enum MovieStatus: String, CaseIterable {
    case upcoming = "Upcoming"
    case popular = "Popular"
    case nowPlaying = "Now Playing"
}

struct Genre: Codable {
    let id: Int
    let name: String
    
    static func retrieveGenreByID(id: Int) -> String {
        let genres = [
            28: "Action",
            12: "Adventure",
            16: "Animation",
            35: "Comedy",
            80: "Crime",
            99: "Documentary",
            18: "Drama",
            10751: "Family",
            14: "Fantasy",
            36: "History",
            27: "Horror",
            10402: "Music",
            9648: "Mystery",
            10749: "Romance",
            878: "Science Fiction",
            10770: "TV Movie",
            53: "Thriller",
            10752: "War",
            37: "Western"
        ]
        
        return genres[id] ?? "Not Found"
    }
    
    static func retrieveGenreTextString(ids: [Int]?) -> String {
        guard let ids = ids else { return "Genre not available"}
        var genres = [String]()
        ids.forEach({
            genres.append(Genre.retrieveGenreByID(id: $0))
        
        })
        
        return genres.joined(separator: ", ")
    }
}

//Upcoming Movie, Now Playing, Popular model
struct Movie: Codable, Hashable {
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let posterPath: String?
    let id: Int
    let adult: Bool
    let backdropPath: String?  //can be null
    let originalLanguage: String
    let originalTitle: String?
    let genreIds: [Int]
    let title: String
    let voteAverage: Double
    let overview: String
    let releaseDate: String  //used MovieReleaseDate instead
}

//MARK: Full Movie Detail Model
struct MovieDetails: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Float
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Float
    let voteCount: Int
}

struct MovieReleaseDateResult: Codable {
    let movieID: Int?
    let results: [MovieReleaseDate]
    
    var unitedStatesReleaseDates: [ReleaseDate]? {
        return results.filter({ $0.iso31661 == "US" }).first?.releaseDates
    }
}

struct MovieReleaseDate: Codable {
    let iso31661: String?
    let releaseDates: [ReleaseDate]
}

struct ReleaseDate: Codable {
    let certification: String?  //rating: ie. R, PG-13, etc
    let iso6391: String?  //Country
    let note: String?
    let releaseDate: String?  //in the following format: "2000-02-10T00:00:00.000Z"
    let type: Int?  //1.Premiere, 2.Theatrical (limited), 3.Theatrical, 4.Digital, 5.Physical, 6.TV
    
    enum ReleaseType: Int {
        case premiere = 1
        case theatricalLimited
        case theatrical
        case digital
        case physical
        case tv
    }
    
    static func retrieveReleaseDate(byType type: ReleaseType, in releaseDates: [ReleaseDate]?) -> String? {
        guard let releaseDates = releaseDates else { return "" }
        //1.Premiere, 2.Theatrical (limited), 3.Theatrical, 4.Digital, 5.Physical, 6.TV
        return releaseDates.filter({ $0.type == type.rawValue }).first?.releaseDate
    }
}

struct Collection: Codable {}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
}

struct ProductionCountry: Codable {
    let iso31661: String
    let name: String
}

struct SpokenLanguage: Codable {
    let iso6391: String
    let name: String
}

//struct ProductionCompany: Codable {
//    let id: Int
//    let logoPath: String
//    let name: String
//    let originCompany: String
//}

//struct ProductionCountry: Codable {
//    let iso_3166_1: String
//    let name: String
//}

struct UpcomingResults: Codable {
    let results: [Movie]?
    let page: Int
    let totalResults: Int
    let dates: ResultDates
    let totalPages: Int
}

struct PopularResults: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
}

struct NowPlayingResults: Codable {
    let page: Int
    let results: [Movie]
    let totalResults: Int
    let totalPages: Int
}

struct ResultDates: Codable {
    let maximum: String
    let minimum: String
}

//MARK: Searching for movie model
struct MovieSearchResults: Codable {
    let page: Int?
    let results: [SearchedMovie]?
    let totalResults: Int?
    let totalPages: Int?
}

struct SearchedMovie: Codable, Hashable {
    let posterPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDate: String?
    let genreIds: [Int]?
    let id: Int?
    let originalTitle: String?
    let originalLanguage: String?
    let title: String?
    let backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?
}


