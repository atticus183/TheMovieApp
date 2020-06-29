import UIKit

var str = "Hello, playground"


let upcomingJSON = """
{
    "results": [
        {
            "popularity": 79.403,
            "id": 619592,
            "video": false,
            "vote_count": 23,
            "vote_average": 5.7,
            "title": "Force of Nature",
            "release_date": "2020-07-02",
            "original_language": "en",
            "original_title": "Force of Nature",
            "genre_ids": [
                28,
                18
            ],
            "backdrop_path": "/jAtO4ci8Tr5jDmg33XF3OZ8VPah.jpg",
            "adult": false,
            "overview": "A gang of thieves plan a heist during a hurricane and encounter trouble when a disgraced cop tries to force everyone in the building to evacuate.",
            "poster_path": "/ucktgbaMSaETUDLUBp1ubGD6aNj.jpg"
        },
        {
            "popularity": 65.617,
            "vote_count": 80,
            "video": false,
            "poster_path": "/fOvqEunubL3wPskvtk2Ficfl0pH.jpg",
            "id": 451184,
            "adult": false,
            "backdrop_path": "/72r4uAQGsa8KEv0DB2TpSu31lEB.jpg",
            "original_language": "en",
            "original_title": "Wasp Network",
            "genre_ids": [
                18,
                36,
                53
            ],
            "title": "Wasp Network",
            "vote_average": 6.4,
            "overview": "Havana, Cuba, 1990. René González, an airplane pilot, unexpectedly flees the country, leaving behind his wife Olga and his daughter Irma, and begins a new life in Miami, where he becomes a member of an anti-Castro organization.",
            "release_date": "2020-01-29"
        },
        {
            "popularity": 50.635,
            "vote_count": 3,
            "video": false,
            "poster_path": "/cgC67SOxd9xkjN4Bnvjtuj1vI8T.jpg",
            "id": 663459,
            "adult": false,
            "backdrop_path": "/vLX1fc75h4CJVjAXPth1SlByBTq.jpg",
            "original_language": "en",
            "original_title": "Jungle Beat: The Movie",
            "genre_ids": [
                16
            ],
            "title": "Jungle Beat: The Movie",
            "vote_average": 4.3,
            "overview": "The Jungle Beat animals think it’s the best thing ever when an alien arrives in the jungle bringing with him the power of speech. They also surprisingly think it’s the best thing ever when they find out that he’s been sent to conquer them.",
            "release_date": "2020-06-26"
        },
        {
            "popularity": 47.311,
            "vote_count": 9,
            "video": false,
            "poster_path": "/zQFjMmE3K9AX5QrBL1SXIxYQ9jz.jpg",
            "id": 579583,
            "adult": false,
            "backdrop_path": "/5rwcd24GGltKiqdPT4G2dmchLr9.jpg",
            "original_language": "en",
            "original_title": "The King of Staten Island",
            "genre_ids": [
                35,
                18
            ],
            "title": "The King of Staten Island",
            "vote_average": 7.1,
            "overview": "Scott has been a case of arrested development ever since his firefighter father died when he was seven. He’s now reached his mid-20s having achieved little, chasing a dream of becoming a tattoo artist that seems far out of reach. As his ambitious younger sister heads off to college, Scott is still living with his exhausted ER nurse mother and spends his days smoking weed, hanging with the guys — Oscar, Igor and Richie — and secretly hooking up with his childhood friend Kelsey. But when his mother starts dating a loudmouth firefighter named Ray, it sets off a chain of events that will force Scott to grapple with his grief and take his first tentative steps toward moving forward in life.",
            "release_date": "2020-07-01"
        },
        {
            "popularity": 50.651,
            "vote_count": 1095,
            "video": false,
            "poster_path": "/jHo2M1OiH9Re33jYtUQdfzPeUkx.jpg",
            "id": 385103,
            "adult": false,
            "backdrop_path": "/fKtYXUhX5fxMxzQfyUcQW9Shik6.jpg",
            "original_language": "en",
            "original_title": "Scoob!",
            "genre_ids": [
                12,
                16,
                35,
                9648,
                10751
            ],
            "title": "Scoob!",
            "vote_average": 8,
            "overview": "In Scooby-Doo’s greatest adventure yet, see the never-before told story of how lifelong friends Scooby and Shaggy first met and how they joined forces with young detectives Fred, Velma, and Daphne to form the famous Mystery Inc. Now, with hundreds of cases solved, Scooby and the gang face their biggest, toughest mystery ever: an evil plot to unleash the ghost dog Cerberus upon the world. As they race to stop this global “dogpocalypse,” the gang discovers that Scooby has a secret legacy and an epic destiny greater than anyone ever imagined.",
            "release_date": "2020-05-15"
        },
        {
            "popularity": 39.25,
            "vote_count": 152,
            "video": false,
            "poster_path": "/MBiKqTsouYqAACLYNDadsjhhC0.jpg",
            "id": 486589,
            "adult": false,
            "backdrop_path": "/bga3i5jcejBekr2FCGJga1fYCh.jpg",
            "original_language": "en",
            "original_title": "Red Shoes and the Seven Dwarfs",
            "genre_ids": [
                16,
                10749,
                10751
            ],
            "title": "Red Shoes and the Seven Dwarfs",
            "vote_average": 6.6,
            "overview": "Princes who have been turned into Dwarfs seek the red shoes of a lady in order to break the spell, although it will not be easy.",
            "release_date": "2019-07-25"
        },
        {
            "popularity": 42.596,
            "vote_count": 472,
            "video": false,
            "poster_path": "/tIpGQ9uuII7QVFF0GHCFTJFfXve.jpg",
            "id": 555974,
            "adult": false,
            "backdrop_path": "/rpGYHowXtjw37UxdwO1ZcK5E8IN.jpg",
            "original_language": "en",
            "original_title": "Brahms: The Boy II",
            "genre_ids": [
                27,
                9648,
                53
            ],
            "title": "Brahms: The Boy II",
            "vote_average": 6.4,
            "overview": "After a family moves into the Heelshire Mansion, their young son soon makes friends with a life-like doll called Brahms.",
            "release_date": "2020-02-20"
        },
        {
            "popularity": 32.061,
            "vote_count": 0,
            "video": false,
            "poster_path": "/wnJkCk3S5u8JYQ0SZOgM4zQ6u1H.jpg",
            "id": 563714,
            "adult": false,
            "backdrop_path": "/wT6eaSxwuUAdCXpz3vS8PRyZyDA.jpg",
            "original_language": "en",
            "original_title": "Puppy Love",
            "genre_ids": [
                35,
                18
            ],
            "title": "Puppy Love",
            "vote_average": 0,
            "overview": "A prophetic young dishwasher with brain-damage and a homeless prostitute are brought together through obscene circumstances and embark on a perverse journey through the gutter.",
            "release_date": "2020-06-28"
        },
        {
            "popularity": 33.538,
            "vote_count": 0,
            "video": false,
            "poster_path": "/goEW6QqoFxNI2pfbpVqmXj2WXwd.jpg",
            "id": 531876,
            "adult": false,
            "backdrop_path": null,
            "original_language": "en",
            "original_title": "The Outpost",
            "genre_ids": [
                18,
                36,
                10752
            ],
            "title": "The Outpost",
            "vote_average": 0,
            "overview": "A small unit of U.S. soldiers, alone at the remote Combat Outpost Keating, located deep in the valley of three mountains in Afghanistan, battles to defend against an overwhelming force of Taliban fighters in a coordinated attack. The Battle of Kamdesh, as it was known, was the bloodiest American engagement of the Afghan War in 2009 and Bravo Troop 3-61 CAV became one of the most decorated units of the 19-year conflict.",
            "release_date": "2020-06-24"
        },
        {
            "popularity": 32.296,
            "vote_count": 579,
            "video": false,
            "poster_path": "/hJ6YEbrjFvToa5c7IiUqILoB6Je.jpg",
            "id": 552178,
            "adult": false,
            "backdrop_path": "/4ZSlTfkHtgTTupCaLbseXQQzZha.jpg",
            "original_language": "en",
            "original_title": "Dark Waters",
            "genre_ids": [
                18,
                53
            ],
            "title": "Dark Waters",
            "vote_average": 7.4,
            "overview": "A tenacious attorney uncovers a dark secret that connects a growing number of unexplained deaths to one of the world's largest corporations. In the process, he risks everything — his future, his family, and his own life — to expose the truth.",
            "release_date": "2019-11-22"
        },
        {
            "popularity": 28.505,
            "vote_count": 1,
            "video": false,
            "poster_path": "/3i6vQ4Mul0Prfv30fYeveUDIoeV.jpg",
            "id": 674773,
            "adult": false,
            "backdrop_path": null,
            "original_language": "en",
            "original_title": "The Unknown Eye",
            "genre_ids": [
                18,
                53,
                10749
            ],
            "title": "The Unknown Eye",
            "vote_average": 1,
            "overview": "A man tries to navigate a deteriorating relationship with his girlfriend as his life is terrorized by a mysterious Stalker.",
            "release_date": "2020-06-28"
        },
        {
            "popularity": 33.092,
            "vote_count": 18,
            "video": false,
            "poster_path": "/uCDcQbfIKY4oTPd6tbghloFm7Gi.jpg",
            "id": 606679,
            "adult": false,
            "backdrop_path": "/aVX9a54YFmrcEHATubpuFQQKn5L.jpg",
            "original_language": "en",
            "original_title": "The High Note",
            "genre_ids": [
                35,
                18,
                10402,
                10749
            ],
            "title": "The High Note",
            "vote_average": 7.8,
            "overview": "Set in the dazzling world of the LA music scene comes the story of Grace Davis, a superstar whose talent, and ego, have reached unbelievable heights. Maggie is Grace’s overworked personal assistant who’s stuck running errands, but still aspires to her childhood dream of becoming a music producer. When Grace’s manager presents her with a choice that could alter the course of her career, Maggie and Grace come up with a plan that could change their lives forever.",
            "release_date": "2020-06-10"
        },
        {
            "popularity": 29.782,
            "vote_count": 15,
            "video": false,
            "poster_path": "/aINpljdt3VVMrCLtJW4BektwYOp.jpg",
            "id": 522098,
            "adult": false,
            "backdrop_path": "/cjAirCV9TyTQcp7mFNRnvgkoVFV.jpg",
            "original_language": "en",
            "original_title": "Babyteeth",
            "genre_ids": [
                35,
                18
            ],
            "title": "Babyteeth",
            "vote_average": 5.2,
            "overview": "A terminally ill teen upsets her parents when she falls in love with a small-time drug dealer.",
            "release_date": "2020-06-18"
        },
        {
            "popularity": 22.51,
            "vote_count": 795,
            "video": false,
            "poster_path": "/izGX7npHEopDQvngYcxMJEfcFbj.jpg",
            "id": 461130,
            "adult": false,
            "backdrop_path": "/wlnDNMQlnwl5ETlVY6n9CEtR5s0.jpg",
            "original_language": "en",
            "original_title": "Code 8",
            "genre_ids": [
                28,
                80,
                18,
                878,
                53
            ],
            "title": "Code 8",
            "vote_average": 6.2,
            "overview": "In Lincoln City, some inhabitants have extraordinary abilities. Most live below the poverty line, under the close surveillance of a heavily militarized police force. Connor, a construction worker with powers, involves with a criminal gang to help his ailing mother. (Based on the short film “Code 8,” 2016.)",
            "release_date": "2019-12-06"
        },
        {
            "popularity": 30.602,
            "vote_count": 1199,
            "video": false,
            "poster_path": "/gbPfvwBqbiHpQkYZQvVwB6MVauV.jpg",
            "id": 525661,
            "adult": false,
            "backdrop_path": "/nj84vpuUWdbmYktBzjiWn5Ny1ZF.jpg",
            "original_language": "en",
            "original_title": "Bombshell",
            "genre_ids": [
                18
            ],
            "title": "Bombshell",
            "vote_average": 6.8,
            "overview": "Bombshell is a revealing look inside the most powerful and controversial media empire of all time; and the explosive story of the women who brought down the infamous man who created it.",
            "release_date": "2019-12-13"
        },
        {
            "popularity": 24.443,
            "vote_count": 162,
            "video": false,
            "poster_path": "/3xbjL0z8iH8e8L3USyeKGQrBfuZ.jpg",
            "id": 533444,
            "adult": false,
            "backdrop_path": "/jQ06O9JAFN0VfDS4ezE09pfoj2h.jpg",
            "original_language": "en",
            "original_title": "Waves",
            "genre_ids": [
                18,
                10749
            ],
            "title": "Waves",
            "vote_average": 7.7,
            "overview": "A controlling father’s attempts to ensure that his two children succeed in high school backfire after his son experiences a career-ending sports injury. Their familial bonds are eventually placed under severe strain by an unexpected tragedy.",
            "release_date": "2019-11-15"
        },
        {
            "popularity": 24.595,
            "vote_count": 0,
            "video": false,
            "poster_path": "/mHdxRpcJuajyYlHdkUP58xUIIl.jpg",
            "id": 707214,
            "adult": false,
            "backdrop_path": "/9GoV8gwMxpI2OrFXtJuyP1xIJ89.jpg",
            "original_language": "en",
            "original_title": "The Clearing",
            "genre_ids": [
                27
            ],
            "title": "The Clearing",
            "vote_average": 0,
            "overview": "A father must battle his way through the zombie apocalypse to save his daughter.",
            "release_date": "2020-07-18"
        },
        {
            "popularity": 23.235,
            "vote_count": 784,
            "video": false,
            "poster_path": "/qCDPKUMX5xrxxQY8XhGVCKO3fks.jpg",
            "id": 599975,
            "adult": false,
            "backdrop_path": "/zETkzgle7c6wAeW11snnVUBp67S.jpg",
            "original_language": "en",
            "original_title": "Countdown",
            "genre_ids": [
                27,
                53
            ],
            "title": "Countdown",
            "vote_average": 6.4,
            "overview": "A young nurse downloads an app that tells her she only has three days to live. With time ticking away and a mysterious figure haunting her, she must find a way to save her life before time runs out.",
            "release_date": "2019-10-24"
        },
        {
            "popularity": 24.317,
            "vote_count": 0,
            "video": false,
            "poster_path": "/7I8BmtqjLyyMf3EjrUEIQs0gFYw.jpg",
            "id": 625568,
            "adult": false,
            "backdrop_path": "/m6zfjXaXhp0EhhT59QV2F55eSQs.jpg",
            "original_language": "en",
            "original_title": "Unhinged",
            "genre_ids": [
                53
            ],
            "title": "Unhinged",
            "vote_average": 0,
            "overview": "A case of road rage turns into full-blown terror when an unstable driver follows a woman and her son.",
            "release_date": "2020-07-03"
        },
        {
            "popularity": 17.071,
            "vote_count": 518,
            "video": false,
            "poster_path": "/4w1ItwCJCTtSi9nPfJC1vU6NIVg.jpg",
            "id": 413518,
            "adult": false,
            "backdrop_path": "/AdqOBPw4PdtzOcfEuQuZ8MNeTKb.jpg",
            "original_language": "it",
            "original_title": "Pinocchio",
            "genre_ids": [
                12,
                18,
                14,
                10751
            ],
            "title": "Pinocchio",
            "vote_average": 6.9,
            "overview": "Live-action adaptation of the classic story of a wooden puppet named Pinocchio who comes to life.",
            "release_date": "2019-12-19"
        }
    ],
    "page": 1,
    "total_results": 192,
    "dates": {
        "maximum": "2020-07-25",
        "minimum": "2020-06-28"
    },
    "total_pages": 10
}
"""

let jsonData = Data(upcomingJSON.utf8)


//Model
struct UpcomingResults: Codable {
    let page: Int?
    let results: [Movie]?
    let totalResults: Int
//    let dates: ResultDates
//    let totalPages: Int
}

struct ResultDates: Codable {
    let maximum: String
    let minimum: String
}

struct Movie: Codable {
    let id: Int?
    let adult: Bool?
    let backdropPath: String?
//    let belongsToCollection: Collection?
    let budget: Int?
//    let genres: [Genre]
    let homepage: String?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
//    let productionCompanies: [ProductionCompany]?
//    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
//    let spokenLanguages: [SpokenLanguage]
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}


let jsonDecoder = JSONDecoder()
jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

do {
    let json = try jsonDecoder.decode(UpcomingResults.self, from: jsonData)
    print("First movie id: \(json.results?.first?.id)")
} catch {
    print("Error: \(error.localizedDescription)")
}
