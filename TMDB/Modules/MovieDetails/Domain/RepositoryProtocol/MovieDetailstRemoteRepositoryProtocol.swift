//
//  MovieDetailstRemoteRepositoryProtocol.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import Foundation
import Combine
import JahezNetwork

 protocol MovieDetailstRemoteRepositoryProtocol {
     func getMovieDetails(request: MovieDetailsRequestModel, movieId: Int) -> AnyPublisher<MovieDetailsResponseModel, NetworkError>
}
