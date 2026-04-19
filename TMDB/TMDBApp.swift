//
//  TMDBApp.swift
//  TMDB
//
//  Created by Mohamed Sadek on 15/04/2026.
//

import SwiftUI

@main
struct TMDBApp: App {
    
    // MARK: init
    init() {
         configureImageCache()
     }
    
    // MARK: Body
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    private func configureImageCache() {
        URLCache.shared = URLCache(
            memoryCapacity: 100 * 1024 * 1024,
            diskCapacity: 500 * 1024 * 1024
        )
    }
}
