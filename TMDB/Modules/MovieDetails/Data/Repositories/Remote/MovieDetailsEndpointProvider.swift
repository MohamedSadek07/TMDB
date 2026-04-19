//
//  MovieDetailsEndpointProvider.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import Foundation
import JahezNetwork
import JahezUtilities

enum MovieDetailsEndpointProvider {
    case details(MovieDetailsRequestModel, Int)
}

extension MovieDetailsEndpointProvider: NetworkRequest {
    var baseURL: String {
        return Constants.baseURL
    }
    var endPoint: String {
        switch self {
        case let .details(_,movieId):
            return "\(EndPoint.movieDetails)/\(movieId)"
        }
    }
    var headers: [String: String]? {
        NetworkHelper.getHeaders()
    }
    var queryParams: [String: Any]? {
        switch self {
        case let .details(params,_):
            return params.asDictionary
        }
    }
    var parameters: [String: Any]? {
        nil
    }
    var method: APIHTTPMethod {
        switch self {
        case .details:
            return .GET
        }
    }
}
