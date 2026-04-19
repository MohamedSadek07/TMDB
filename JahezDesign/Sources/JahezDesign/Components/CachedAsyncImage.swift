//
//  CachedAsyncImage.swift
//  JahezDesign
//
//  Created by Mohamed Sadek on 19/04/2026.
//

import Foundation
import SwiftUI

// MARK: - CachedAsyncImage
/// Cached Async Image first load cached image if not exist Request Async Image
struct CachedAsyncImage: View {
    // Variables
    let url: String
    
    // Body
    var body: some View {
        if let cached = loadFromCache(url) {
            Image(uiImage: cached)
                .resizable()
                .scaledToFill()
        } else {
            AsyncImageLoader(url: url)
        }
    }
    
    private func loadFromCache(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let request = URLRequest(url: url)
        guard let data = URLCache.shared.cachedResponse(for: request)?.data else { return nil }
        return UIImage(data: data)
    }
}


// MARK: - AsyncImageLoader
public struct AsyncImageLoader: View {
    // Variables
    let url: String
    @State private var image: UIImage?
    @State private var isLoading = true
    
    public init(url: String, image: UIImage? = nil, isLoading: Bool = true) {
        self.url = url
        self.image = image
        self.isLoading = isLoading
    }

    // Body
    public var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                Rectangle()
                    .fill(Color.white.opacity(0.07))
                    .overlay(ProgressView().tint(.white.opacity(0.4)))
            } else {
                Rectangle()
                    .fill(Color.white.opacity(0.07))
                    .overlay(
                        Image(systemName: "film")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.3))
                    )
            }
        }
        .task { await loadImage() }
    }
    
    private func loadImage() async {
        guard let url = URL(string: url) else { isLoading = false; return }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Save to cache manually
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            
            if let uiImage = UIImage(data: data) {
                await MainActor.run { image = uiImage }
            }
        } catch {
            await MainActor.run { isLoading = false }
        }
        
        await MainActor.run { isLoading = false }
    }
}
