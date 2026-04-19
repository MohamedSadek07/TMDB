//
//  GenreMoviesListResponseModel.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

// MARK: - GenreMoviesListResponseModel
struct GenreMoviesListResponseModel: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Hashable {
    let id: Int?
    let name: String?
}
