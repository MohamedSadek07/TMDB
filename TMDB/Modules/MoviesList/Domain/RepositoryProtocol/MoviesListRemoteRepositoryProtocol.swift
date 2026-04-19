//
//  MoviesListRemoteRepositoryProtocol.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

import Foundation
import JahezNetwork
import Combine

 protocol MoviesListRemoteRepositoryProtocol {
     func getGenresList(request: GenreMoviesListRequestModel) -> AnyPublisher<GenreMoviesListResponseModel, NetworkError>
     
     func getMoviesList(request: MoviesListRequestModel) -> AnyPublisher<MoviesListResponseModel, NetworkError>
}
