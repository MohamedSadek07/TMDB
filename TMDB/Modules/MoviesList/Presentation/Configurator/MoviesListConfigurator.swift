//
//  MoviesListConfigurator.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

final class MoviesListConfigurator {
    static func configureModule() ->  MoviesListView {
        let remoteRepo = MoviesListRemoteRepository()
        let useCase = MoviesListUseCase(moviesListRemoteRepository: remoteRepo)
        let viewModel = MoviesListViewModel(moviesListUseCase: useCase)
        let view = MoviesListView(viewModel: viewModel)
        return view
    }
}
