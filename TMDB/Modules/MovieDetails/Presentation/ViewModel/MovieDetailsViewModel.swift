//
//  MovieDetailsViewModel.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import Foundation
import Combine
import JahezUtilities

class MovieDetailsViewModel: ObservableObject {

    // Variables
    private let movieDetailsUseCase: MovieDetailsUseCaseProtocol
    private var cancelable: Set<AnyCancellable> = []
    var sentMovieId = 0
    // Published Variables
    @Published var isLoading = false
    @Published var movieDetails = MovieDetails()

    // MARK: - init
    init(movieDetailsUseCase: MovieDetailsUseCaseProtocol, passedMovieId: Int) {
        self.movieDetailsUseCase = movieDetailsUseCase
        sentMovieId = passedMovieId
    }
    // MARK: - Methods
    private func getMovieDetails() {
        isLoading = true
        movieDetailsUseCase.getMovieDetails(
            request: MovieDetailsRequestModel(language: "en-US"),
            movieId: sentMovieId
        ).sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    Log.error("get Movie Details Error \(err)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else {return}
                movieDetails = response.toDetails()
            }).store(in: &cancelable)
    }
    func callGetMovieDetails() {
        getMovieDetails()
    }
}
