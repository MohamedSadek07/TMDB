//
//  MovieAsyncImage.swift
//  JahezDesign
//
//  Created by Mohamed Sadek on 19/04/2026.
//

import SwiftUI

public struct MovieAsyncImage: View {
    let url: String
    

    public init(url: String) {
        self.url = url
    }

    public var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
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
    }
}
