//
//  MovieCardView.swift
//  JahezDesign
//
//  Created by Mohamed Sadek on 18/04/2026.
//

import SwiftUI

// MARK: - Model
public struct Movie: Identifiable {
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


// MARK: - Movie Card View
public struct MovieCardView: View {
    let movie: Movie
    
    public init(movie: Movie) {
        self.movie = movie
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: Poster Image
            AsyncImage(url: URL(string: movie.posterURL)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.white.opacity(0.07))
                        .overlay(ProgressView().tint(.white.opacity(0.4)))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Rectangle()
                        .fill(Color.white.opacity(0.07))
                        .overlay(
                            Image(systemName: "film")
                                .font(.system(size: 28))
                                .foregroundStyle(.white.opacity(0.3))
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
            .clipped()

            // MARK: Info Section
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(movie.year)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        }
    }
}
