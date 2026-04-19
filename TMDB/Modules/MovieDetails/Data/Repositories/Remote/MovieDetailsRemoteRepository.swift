//
//  MovieDetailsRemoteRepository.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import Foundation
import Combine
import JahezNetwork


class MovieDetailsRemoteRepository: MovieDetailstRemoteRepositoryProtocol {
    private let networkClient = NetworkClient(configuration: URLSession.shared.configuration, session: .shared)

    func getMovieDetails(request: MovieDetailsRequestModel, movieId: Int) -> AnyPublisher<MovieDetailsResponseModel, NetworkError> {
        networkClient.request(request: MovieDetailsEndpointProvider.details(request, movieId).makeRequest, mapToModel: MovieDetailsResponseModel.self)
    }
}
