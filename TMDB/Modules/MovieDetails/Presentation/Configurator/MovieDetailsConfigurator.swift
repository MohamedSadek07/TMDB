//
//  MovieDetailsConfigurator.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

final class MovieDetailsConfigurator {
    static func configureModule(passedMovieId: Int) ->  MovieDetailsView {
        let remoteRepo = MovieDetailsRemoteRepository()
        let useCase = MovieDetailsUseCase(movieDetailstRemoteRepository: remoteRepo)
        let viewModel = MovieDetailsViewModel(
            movieDetailsUseCase: useCase,
            passedMovieId: passedMovieId
        )
        let view = MovieDetailsView(viewModel: viewModel)
        return view
    }
}


