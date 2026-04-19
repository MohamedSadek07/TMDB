//
//  MoviesCacher.swift
//  JahezUtilities
//
//  Created by Mohamed Sadek on 19/04/2026.
//

import Foundation

public protocol MoviesCacherProtocol {
    func save(_ movies: [Movie])
    func load() -> [Movie]
    func clear()
}

public final class MoviesCacher: MoviesCacherProtocol {
    private let key = "cached_movies"
    
    public init() {}
    
    public func save(_ movies: [Movie]) {
        guard let encoded = try? JSONEncoder().encode(movies) else { return }
        UserDefaults.standard.set(encoded, forKey: key)
    }
    
    public func load() -> [Movie] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let movies = try? JSONDecoder().decode([Movie].self, from: data)
        else { return [] }
        return movies
    }
    
    public func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
