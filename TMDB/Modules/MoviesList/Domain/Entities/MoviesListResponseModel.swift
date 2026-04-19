//
//  MoviesListResponseModel.swift
//  TMDB
//
//  Created by Mohamed Sadek on 19/04/2026.
//

// MARK: - LocationInfoResponseModel
struct MoviesListResponseModel: Codable {
    let page: Int?
    let results: [MoviesListResult]?
    let totalPages, totalResults: Int?
}

// MARK: - Result
struct MoviesListResult: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath
        case genreIDS = "genre_ids"
        case id
        case originalLanguage
        case originalTitle
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage
        case voteCount
    }
}
