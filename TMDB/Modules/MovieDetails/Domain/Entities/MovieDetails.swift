//
//  MovieDetails.swift
//  TMDB
//
//  Created by Mohamed Sadek on 19/04/2026.
//

public struct MovieDetails {
    public let id: Int
    public let title: String
    public let backdropURL: String
    public let posterURL: String
    public let releaseDate: String
    public let genres: [String]
    public let overview: String
    public let homepage: String
    public let budget: Int
    public let revenue: Int
    public let spokenLanguages: [String]
    public let status: String
    public let runtime: Int

    public init(
        id: Int = 0,
        title: String = "",
        backdropURL: String = "",
        posterURL: String = "",
        releaseDate: String = "",
        genres: [String] = [],
        overview: String = "",
        homepage: String = "",
        budget: Int = 0,
        revenue: Int = 0,
        spokenLanguages: [String] = [],
        status: String = "",
        runtime: Int = 0
    ) {
        self.id = id
        self.title = title
        self.backdropURL = backdropURL
        self.posterURL = posterURL
        self.releaseDate = releaseDate
        self.genres = genres
        self.overview = overview
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.runtime = runtime
    }
}
