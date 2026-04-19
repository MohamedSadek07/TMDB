//
//  MovieDetailsUseCase.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import Combine
import JahezNetwork

protocol MovieDetailsUseCaseProtocol: AnyObject {
    func getMovieDetails(request: MovieDetailsRequestModel, movieId: Int) -> AnyPublisher<MovieDetailsResponseModel, NetworkError>
}

class MovieDetailsUseCase: MovieDetailsUseCaseProtocol {
    private let movieDetailstRemoteRepository: MovieDetailstRemoteRepositoryProtocol
    /// Initialize the interactor with the required parameters to work properly
    init(movieDetailstRemoteRepository: MovieDetailstRemoteRepositoryProtocol) {
        self.movieDetailstRemoteRepository = movieDetailstRemoteRepository
    }

    func getMovieDetails(request: MovieDetailsRequestModel, movieId: Int) -> AnyPublisher<MovieDetailsResponseModel, NetworkError> {
        movieDetailstRemoteRepository.getMovieDetails(request: request, movieId: movieId)
    }
}
