//
//  SearchBar.swift
//  JahezDesign
//
//  Created by Mohamed Sadek on 19/04/2026.
//

import SwiftUI

// MARK: Search Bar
public struct SearchBar: View {
    @Binding var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.35))

            TextField("", text: $text,
                      prompt: Text("Search TMDB").foregroundColor(.white.opacity(0.35)))
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.85))

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
            } else {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
