//
//  Movie.swift
//  JahezUtilities
//
//  Created by Mohamed Sadek on 19/04/2026.
//

// MARK: - Model
public struct Movie: Identifiable, Codable {
    public let id: Int
    public let title: String
    public let year: String
    public let posterURL: String
    public let genreIds: [Int]
    
    public init(
        id: Int,
        title: String,
        year: String,
        posterURL: String,
        genreIds: [Int]
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.posterURL = posterURL
        self.genreIds = genreIds
    }
}
