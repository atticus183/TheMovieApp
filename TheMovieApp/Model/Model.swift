//
//  Model.swift
//  TheMovieApp
//
//  Created by Josh R on 12/29/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation

enum MovieStatus: String, CaseIterable {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case upcoming = "Upcoming"
}

struct Genre: Codable, Hashable {
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
}


//Conform to Hashable so its objects can be used with the DiffableDatasource API
struct Movie: Codable, Hashable {
    let id: Int?
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int?
    let genres: [Genre]?
    let genreIds: [Int]?
    let homepage: String?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Int?
    
    var genresString: String {
        if let genres = genres, genres.count > 0 {
            return genres.map({ $0.name }).joined(separator: ", ")
        }
        
        if let genreIds = genreIds, genreIds.count > 0 {
            let genres = genreIds.map({ Genre.retrieveGenreByID(id: $0) }).joined(separator: ", ")
            return genres
        }
        
        return "Genre Not Available"
    }
    
    var releaseDateFormatted: String {
        return DateFormatters.changeStringDateFormat(from: self.releaseDate ?? "")
    }
    
    var releaseDateObject: Date? {
        return DateFormatters.toDate(from: self.releaseDate)
    }
    
    func retrieveImgURLString(with size: TMDbManager.ImgSize) -> String {
           let backDrop = self.backdropPath ?? ""
           let posterPath = self.posterPath ?? ""
           
           if size.rawValue.contains("backdrop") {
               return TMDbManager.imgBaseURL + "\(size.sizeString)/\(backDrop)"
           } else if size.rawValue.contains("logo") {
               return ""
           } else if size.rawValue.contains("poster") {
               return TMDbManager.imgBaseURL + "\(size.sizeString)/\(posterPath)"
           } else {
               return ""
           }
       }
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

struct Collection: Codable, Hashable {}

struct ProductionCompany: Codable, Hashable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
}

struct ProductionCountry: Codable, Hashable {
    let iso31661: String
    let name: String
}

struct SpokenLanguage: Codable, Hashable {
    let iso6391: String
    let name: String
}

struct UpcomingResults: Codable {
    let results: [Movie]?
    let dates: ResultDates?
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
    let maximum: String?
    let minimum: String?
}

//MARK: Searching for movie model
struct MovieSearchResults: Codable {
    let page: Int?
    let results: [Movie]?
    let totalResults: Int?
    let totalPages: Int?
}
