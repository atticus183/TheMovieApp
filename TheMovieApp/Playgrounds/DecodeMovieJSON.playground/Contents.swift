import UIKit

let frozenJSON = """
{
  "adult": false,
  "backdrop_path": "/pNbmSYUtMd542OATplZIdtSWKyz.jpg",
  "belongs_to_collection": {
    "id": 386382,
    "name": "Frozen Collection",
    "poster_path": "/13Op41T3cALJedrKqYPrlc3cIbO.jpg",
    "backdrop_path": "/6QonAoIN0jhWZZWZGJswSxHzUnU.jpg"
  },
  "budget": 150000000,
  "genres": [
    {
      "id": 16,
      "name": "Animation"
    },
    {
      "id": 10751,
      "name": "Family"
    },
    {
      "id": 12,
      "name": "Adventure"
    }
  ],
  "homepage": "https://movies.disney.com/frozen-2",
  "id": 330457,
  "imdb_id": "tt4520988",
  "original_language": "en",
  "original_title": "Frozen II",
  "overview": "Elsa, Anna, Kristoff and Olaf head far into the forest to learn the truth about an ancient mystery of their kingdom.",
  "popularity": 59.941,
  "poster_path": "/pjeMs3yqRmFL3giJy4PMXWZTTPa.jpg",
  "production_companies": [
    {
      "id": 6125,
      "logo_path": "/tVPmo07IHhBs4HuilrcV0yujsZ9.png",
      "name": "Walt Disney Animation Studios",
      "origin_country": "US"
    },
    {
      "id": 2,
      "logo_path": "/wdrCwmRnLFJhEoH8GSfymY85KHT.png",
      "name": "Walt Disney Pictures",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {
      "iso_3166_1": "US",
      "name": "United States of America"
    }
  ],
  "release_date": "2019-11-20",
  "revenue": 1450026933,
  "runtime": 104,
  "spoken_languages": [
    {
      "iso_639_1": "en",
      "name": "English"
    }
  ],
  "status": "Released",
  "tagline": "The past is not what it seems.",
  "title": "Frozen II",
  "video": false,
  "vote_average": 7.3,
  "vote_count": 5104
}
"""

let jsonData = Data(frozenJSON.utf8)

//MARK: Movie Model
struct MovieDetails: Codable {
    let id: Int?
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int
    let genres: [Genre]?
    let genreIds: [Int]?
    let homepage: String?
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Float
    let posterPath: String?
//    let productionCompanies: [ProductionCompany]
//    let productionCountries: [ProductionCountry]
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
//    let spokenLanguages: [SpokenLanguage]
    let status: String?
    let tagline: String?
    let title: String?
    let voteAverage: Float
    let voteCount: Int
}

struct Collection: Codable {}

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


let jsonDecoder = JSONDecoder()
jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

do {
    let json = try jsonDecoder.decode(MovieDetails.self, from: jsonData)
    print(json.id!)
    print(Genre.retrieveGenreByID(id: json.genres!.first!.id))
} catch {
    print("Error: \(error.localizedDescription)")
}
