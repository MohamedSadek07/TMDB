//
//  NetworkErrors.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

public enum NetworkError: Error {
    case normalError(Error)
    case notValidURL
    case unAuthorithed
    case requestFailed
    case emptyErrorWithStatusCode(String)
    case decodeFailed
}
