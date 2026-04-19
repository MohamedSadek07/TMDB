//
//  MoviesListRemoteRepository.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

import Foundation
import JahezNetwork
import Combine

class MoviesListRemoteRepository: MoviesListRemoteRepositoryProtocol {
    private let networkClient = NetworkClient(configuration: URLSession.shared.configuration, session: .shared)

    func getGenresList(request: GenreMoviesListRequestModel) -> AnyPublisher<GenreMoviesListResponseModel, NetworkError> {
        networkClient.request(
            request: MoviesListEndpointProvider.genreList(request).makeRequest,
            mapToModel: GenreMoviesListResponseModel.self
        )
    }
    
    func getMoviesList(request: MoviesListRequestModel) -> AnyPublisher<MoviesListResponseModel, JahezNetwork.NetworkError> {
        networkClient.request(
            request: MoviesListEndpointProvider.moviesList(request).makeRequest,
            mapToModel: MoviesListResponseModel.self
        )
    }
}
