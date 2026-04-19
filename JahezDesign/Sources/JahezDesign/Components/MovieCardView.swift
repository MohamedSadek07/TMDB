//
//  MovieCardView.swift
//  JahezDesign
//
//  Created by Mohamed Sadek on 18/04/2026.
//

import SwiftUI
import JahezUtilities

// MARK: - Movie Card View
public struct MovieCardView: View {
    let movie: Movie
    
    public init(movie: Movie) {
        self.movie = movie
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: Poster Image
            CachedAsyncImage(url: movie.posterURL)
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
