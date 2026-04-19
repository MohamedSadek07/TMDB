//
//  MoviesListViewModel.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

import Foundation
import Combine
import JahezDesign
import JahezNetwork

class MoviesListViewModel: ObservableObject {

    // Variables
    private let moviesListUseCase: MoviesListUseCaseProtocol
    private var cancelable: Set<AnyCancellable> = []
    private var timerCancellable: AnyCancellable?
    // Published Variables
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var genresArray: [Genre] = []
    @Published var moviesArray: [Movie] = []
    @Published var pageNumber = 1
    @Published var canLoadMorePages = true
    @Published var selectedGenreId = 0 {
        didSet {
            applyFilters()
        }
    }
    @Published var searchText = "" {
        didSet {
            applyFilters()
        }
    }
    private var allMovies: [Movie] = []

    // MARK: - init
    init(moviesListUseCase: MoviesListUseCaseProtocol) {
        self.moviesListUseCase = moviesListUseCase
    }
    // MARK: - Methods
    private func getGenresList() {
        isLoading = true
        moviesListUseCase.getGenresList(request: GenreMoviesListRequestModel(language: "en"))
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    Log.error("getGenresList Error \(err)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else {return}
                genresArray = response.genres
            }).store(in: &cancelable)
    }
    
    private func getMoviesList() {
        guard !isLoadingMore else { return }
        
        if pageNumber == 1 {
            isLoading = true
        } else {
            isLoadingMore = true
        }
        let requestModel = MoviesListRequestModel(
            includeAdult: false,
            includeVideo: false,
            language: "en",
            page: pageNumber,
            sortBy: "original_title.asc"
        )
        moviesListUseCase.getMoviesList(
            request: requestModel
        )
        .sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                self.isLoading = false
                self.isLoadingMore = false
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    Log.error("getMovies Error \(err)")
                }
            },
            receiveValue: { [weak self] response in
                guard let self = self else {return}
               
                let newMovies = mapMovies(response)
                
                if self.pageNumber == 1 {
                    self.allMovies = newMovies
                } else {
                    self.allMovies.append(contentsOf: newMovies)
                }
                
                self.applyFilters()
                
                // Check if we can load more pages
                self.canLoadMorePages = !newMovies.isEmpty
                self.isLoading = false
                self.isLoadingMore = false
                
            }).store(in: &cancelable)
    }
    func callViewRequests() {
        getGenresList()
        getMoviesList()
    }
}

// MARK: - Extension
extension MoviesListViewModel {
    // MARK: Helper Methods
    private func getYearFromDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            let year = Calendar.current.dateComponents([.year], from: date).year
            return "\(year ?? 0)"
        } else {
            return ""
        }
    }
    func loadMoreMovies() {
        guard canLoadMorePages && !isLoadingMore && !isLoading else { return }
        pageNumber += 1
        getMoviesList()
    }
    private func mapMovies(_ response: MoviesListResponseModel) -> [Movie] {
        return response.results?.map {
            Movie(
                id: $0.id ?? 0,
                title: $0.title ?? "",
                year: self.getYearFromDate($0.releaseDate ?? ""),
                posterURL: Constants.postureBaseUrl + ($0.posterPath ?? ""),
                genreIds: $0.genreIDS ?? []
            )
        } ?? []
    }
    private func applyFilters() {
        var result = allMovies

        // Apply genre filter
        if selectedGenreId != 0 {
            result = result.filter { $0.genreIds.contains(selectedGenreId) }
        }

        // Apply search filter on top
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }

        moviesArray = result
    }
}
