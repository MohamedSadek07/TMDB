//
//  MoviesListUseCase.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import JahezNetwork
import Combine


protocol MoviesListUseCaseProtocol: AnyObject {
    func getGenresList(request: GenreMoviesListRequestModel) -> AnyPublisher<GenreMoviesListResponseModel, NetworkError>
    
    func getMoviesList(request: MoviesListRequestModel) -> AnyPublisher<MoviesListResponseModel, NetworkError>
}

class MoviesListUseCase: MoviesListUseCaseProtocol {
    private let moviesListRemoteRepository: MoviesListRemoteRepositoryProtocol
    /// Initialize the interactor with the required parameters to work properly
    init(moviesListRemoteRepository: MoviesListRemoteRepositoryProtocol) {
        self.moviesListRemoteRepository = moviesListRemoteRepository
    }

    func getGenresList(request: GenreMoviesListRequestModel) -> AnyPublisher<GenreMoviesListResponseModel, NetworkError> {
        moviesListRemoteRepository.getGenresList(request: request)
    }
    
    func getMoviesList(request: MoviesListRequestModel) -> AnyPublisher<MoviesListResponseModel, NetworkError> {
        moviesListRemoteRepository.getMoviesList(request: request)
    }
}
