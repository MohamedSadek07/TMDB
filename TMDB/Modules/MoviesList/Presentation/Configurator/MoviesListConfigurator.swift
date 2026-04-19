//
//  MoviesListConfigurator.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

import JahezUtilities

final class MoviesListConfigurator {
    static func configureModule() ->  MoviesListView {
        let remoteRepo = MoviesListRemoteRepository()
        let useCase = MoviesListUseCase(moviesListRemoteRepository: remoteRepo)
        let moviesCacher = MoviesCacher()
        let viewModel = MoviesListViewModel(
            moviesListUseCase: useCase,
            moviesCacher: moviesCacher
        )
        let view = MoviesListView(viewModel: viewModel)
        return view
    }
}
