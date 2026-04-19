//
//  MoviesListEndpointProvider.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import Foundation
import JahezNetwork
import JahezUtilities

enum MoviesListEndpointProvider {
    case genreList(GenreMoviesListRequestModel)
    case moviesList(MoviesListRequestModel)
}

extension MoviesListEndpointProvider: NetworkRequest {
    var baseURL: String {
        return Constants.baseURL
    }
    var endPoint: String {
        switch self {
        case .genreList:
            return EndPoint.genresList
        case .moviesList:
            return EndPoint.moviesList
        }
    }
    var headers: [String: String]? {
        NetworkHelper.getHeaders()
    }
    var queryParams: [String: Any]? {
        switch self {
        case let .genreList(params):
            return params.asDictionary
        case let .moviesList(params):
            return params.asDictionary
        }
    }
    var parameters: [String: Any]? {
        nil
    }
    var method: APIHTTPMethod {
        switch self {
        case .genreList:
            return .GET
        case .moviesList:
            return .GET
        }
    }
}

