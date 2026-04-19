//
//  MoviesListViewModelTests.swift
//  TMDBTests
//
//  Created by Mohamed Sadek on 19/04/2026.
//

import XCTest
import Combine
import JahezNetwork
import JahezUtilities
@testable import TMDB

// MARK: - Mocks

final class MockMoviesListUseCase: MoviesListUseCaseProtocol {
    var genresResult: Result<GenreMoviesListResponseModel, NetworkError> = .success(.init(genres: []))
    var moviesResult: Result<MoviesListResponseModel, NetworkError> = .success(.init(page: 1, results: [], totalPages: 1, totalResults: 0))

    func getGenresList(request: GenreMoviesListRequestModel) -> AnyPublisher<GenreMoviesListResponseModel, NetworkError> {
        switch genresResult {
        case .success(let value):
            return Just(value)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }

    func getMoviesList(request: MoviesListRequestModel) -> AnyPublisher<MoviesListResponseModel, NetworkError> {
        switch moviesResult {
        case .success(let value):
            return Just(value)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}

final class MockMoviesCacher: MoviesCacherProtocol {
    var savedMovies: [Movie] = []
    var loadCalled = false
    var saveCalled = false

    func save(_ movies: [Movie]) {
        saveCalled = true
        savedMovies = movies
    }

    func load() -> [Movie] {
        loadCalled = true
        return savedMovies
    }

    func clear() {
        savedMovies = []
    }
}

// MARK: - Helpers

extension MoviesListResult {
    static func make(id: Int, title: String, posterPath: String = "", releaseDate: String = "2023-01-01", genreIds: [Int] = []) -> MoviesListResult {
        MoviesListResult(
            adult: false,
            backdropPath: nil,
            genreIDS: genreIds,
            id: id,
            originalLanguage: "en",
            originalTitle: title,
            overview: "",
            popularity: 1.0,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: false,
            voteAverage: 7.0,
            voteCount: 100
        )
    }
}

extension MoviesListResponseModel {
    static func make(results: [MoviesListResult], page: Int = 1, totalPages: Int = 5) -> MoviesListResponseModel {
        MoviesListResponseModel(page: page, results: results, totalPages: totalPages, totalResults: results.count)
    }
}

// MARK: - Tests

final class MoviesListViewModelTests: XCTestCase {

    var sut: MoviesListViewModel!
    var mockUseCase: MockMoviesListUseCase!
    var mockCacher: MockMoviesCacher!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockUseCase = MockMoviesListUseCase()
        mockCacher = MockMoviesCacher()
        sut = MoviesListViewModel(
            moviesListUseCase: mockUseCase,
            moviesCacher: mockCacher
        )
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockCacher = nil
        cancellables = []
        super.tearDown()
    }

    // MARK: - Genres

    func test_getGenresList_success_populatesGenresArray() {
        // Given
        let genres = [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Comedy")]
        mockUseCase.genresResult = .success(GenreMoviesListResponseModel(genres: genres))

        // When
        let expectation = expectation(description: "genres loaded")
        sut.$genresArray
            .dropFirst()
            .sink { genres in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.callViewRequests()

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(sut.genresArray.count, 2)
        XCTAssertEqual(sut.genresArray.first?.name, "Action")
    }

    func test_getGenresList_failure_genresArrayRemainsEmpty() {
        // Given
        mockUseCase.genresResult = .failure(.requestFailed)
        mockUseCase.moviesResult = .success(.make(results: []))

        // When
        sut.callViewRequests()

        // Then
        XCTAssertTrue(sut.genresArray.isEmpty)
    }

    // MARK: - Movies

    func test_getMoviesList_success_populatesMoviesArray() {
        // Given
        let results = [
            MoviesListResult.make(id: 1, title: "Inception"),
            MoviesListResult.make(id: 2, title: "Interstellar")
        ]
        mockUseCase.moviesResult = .success(.make(results: results))

        // When
        let expectation = expectation(description: "movies loaded")
        sut.$moviesArray
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.callViewRequests()

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(sut.moviesArray.count, 2)
        XCTAssertEqual(sut.moviesArray.first?.title, "Inception")
    }

    func test_getMoviesList_savesToCache_onFirstPage() {
        // Given
        let results = [MoviesListResult.make(id: 1, title: "Dune")]
        mockUseCase.moviesResult = .success(.make(results: results))

        // When
        let expectation = expectation(description: "movies loaded")
        sut.$moviesArray
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.callViewRequests()
        waitForExpectations(timeout: 1)

        // Then
        XCTAssertTrue(mockCacher.saveCalled)
        XCTAssertEqual(mockCacher.savedMovies.count, 1)
    }

    func test_getMoviesList_failure_isLoadingBecomeFalse() {
        // Given
        mockUseCase.moviesResult = .failure(.requestFailed)

        // When
        sut.callViewRequests()

        // Then
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Pagination

    func test_loadMoreMovies_incrementsPageAndFetchesMore() {
        // Given — load page 1 first
        let page1 = [MoviesListResult.make(id: 1, title: "Movie 1")]
        mockUseCase.moviesResult = .success(.make(results: page1))

        let firstLoad = expectation(description: "page 1 loaded")
        sut.$moviesArray
            .dropFirst()
            .first()
            .sink { _ in firstLoad.fulfill() }
            .store(in: &cancellables)

        sut.callViewRequests()
        waitForExpectations(timeout: 1)

        // Given — page 2
        let page2 = [MoviesListResult.make(id: 2, title: "Movie 2")]
        mockUseCase.moviesResult = .success(.make(results: page2))

        let secondLoad = expectation(description: "page 2 loaded")
        sut.$moviesArray
            .dropFirst()
            .sink { movies in
                if movies.count == 2 { secondLoad.fulfill() }
            }
            .store(in: &cancellables)

        // When
        sut.loadMoreMovies()

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(sut.moviesArray.count, 2)
        XCTAssertEqual(sut.pageNumber, 2)
    }

    func test_loadMoreMovies_doesNotFetch_whenOffline() {
        // Given
        sut.isOffline = true
        let initialPage = sut.pageNumber

        // When
        sut.loadMoreMovies()

        // Then
        XCTAssertEqual(sut.pageNumber, initialPage)
    }

    func test_loadMoreMovies_doesNotFetch_whenAlreadyLoading() {
        // Given
        sut.isLoading = true
        let initialPage = sut.pageNumber

        // When
        sut.loadMoreMovies()

        // Then
        XCTAssertEqual(sut.pageNumber, initialPage)
    }

    func test_canLoadMorePages_becomeFalse_whenEmptyPageReturned() {
        // Given
        mockUseCase.moviesResult = .success(.make(results: []))

        // When
        let expectation = expectation(description: "empty page received")
        sut.$canLoadMorePages
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        sut.callViewRequests()
        waitForExpectations(timeout: 1)

        // Then
        XCTAssertFalse(sut.canLoadMorePages)
    }

    // MARK: - Search Filter

    func test_searchText_filtersMoviesLocally() {
        // Given
        let results = [
            MoviesListResult.make(id: 1, title: "Inception"),
            MoviesListResult.make(id: 2, title: "Interstellar"),
            MoviesListResult.make(id: 3, title: "Dunkirk")
        ]
        mockUseCase.moviesResult = .success(.make(results: results))

        let loaded = expectation(description: "movies loaded")
        sut.$moviesArray
            .dropFirst()
            .first()
            .sink { _ in loaded.fulfill() }
            .store(in: &cancellables)

        sut.callViewRequests()
        waitForExpectations(timeout: 1)

        // When
        sut.searchText = "inter"

        // Then
        XCTAssertEqual(sut.moviesArray.count, 1)
        XCTAssertEqual(sut.moviesArray.first?.title, "Interstellar")
    }

    func test_searchText_cleared_restoresAllMovies() {
        // Given
        let results = [
            MoviesListResult.make(id: 1, title: "Inception"),
            MoviesListResult.make(id: 2, title: "Dunkirk")
        ]
        mockUseCase.moviesResult = .success(.make(results: results))

        let loaded = expectation(description: "movies loaded")
        sut.$moviesArray
            .dropFirst()
            .first()
            .sink { _ in loaded.fulfill() }
            .store(in: &cancellables)

        sut.callViewRequests()
        waitForExpectations(timeout: 1)

        // When
        sut.searchText = "Inception"
        XCTAssertEqual(sut.moviesArray.count, 1)

        sut.searchText = ""
        XCTAssertEqual(sut.moviesArray.count, 2)
    }

    // MARK: - Genre Filter

    func test_selectedGenreId_filtersMoviesByGenre() {
        // Given
        let results = [
            MoviesListResult.make(id: 1, title: "Inception", genreIds: [28]),
            MoviesListResult.make(id: 2, title: "Toy Story", genreIds: [16]),
            MoviesListResult.make(id: 3, title: "Shrek", genreIds: [16])
        ]
        mockUseCase.moviesResult = .success(.make(results: results))

        let loaded = expectation(description: "movies loaded")
        sut.$moviesArray
            .dropFirst()
            .first()
            .sink { _ in loaded.fulfill() }.store(in: &cancellables)
        sut.callViewRequests()
        waitForExpectations(timeout: 1)

        // When
        sut.selectedGenreId = 16

        // Then
        XCTAssertEqual(sut.moviesArray.count, 2)
        XCTAssertTrue(sut.moviesArray.allSatisfy { $0.genreIds.contains(16) })
    }

    func test_deselectGenre_restoresAllMovies() {
        // Given
        let results = [
            MoviesListResult.make(id: 1, title: "Inception", genreIds: [28]),
            MoviesListResult.make(id: 2, title: "Toy Story", genreIds: [16]),
        ]
        mockUseCase.moviesResult = .success(.make(results: results))

        let loaded = expectation(description: "movies loaded")
        sut.$moviesArray
            .dropFirst()
            .first()
            .sink { _ in loaded.fulfill() }.store(in: &cancellables)
        sut.callViewRequests()
        waitForExpectations(timeout: 1)

        sut.selectedGenreId = 16
        XCTAssertEqual(sut.moviesArray.count, 1)

        // When — deselect by setting back to 0
        sut.selectedGenreId = 0

        // Then
        XCTAssertEqual(sut.moviesArray.count, 2)
    }

    func test_searchAndGenreFilter_appliedTogether() {
        // Given
        let results = [
            MoviesListResult.make(id: 1, title: "Toy Story", genreIds: [16]),
            MoviesListResult.make(id: 2, title: "Toy Story 2", genreIds: [16]),
            MoviesListResult.make(id: 3, title: "Inception", genreIds: [28]),
        ]
        mockUseCase.moviesResult = .success(.make(results: results))

        let loaded = expectation(description: "movies loaded")
        sut.$moviesArray
            .dropFirst()
            .first()
            .sink { _ in loaded.fulfill() }.store(in: &cancellables)
        sut.callViewRequests()
        waitForExpectations(timeout: 1)

        // When — filter by genre 16 AND search "2"
        sut.selectedGenreId = 16
        sut.searchText = "2"

        // Then — only "Toy Story 2" matches both
        XCTAssertEqual(sut.moviesArray.count, 1)
        XCTAssertEqual(sut.moviesArray.first?.title, "Toy Story 2")
    }

    // MARK: - Cache

    func test_loadFromCache_populatesMoviesWhenOffline() {
        // Given
        let cachedMovies = [
            Movie(id: 1, title: "Cached Movie", year: "2023", posterURL: "", genreIds: [])
        ]
        mockCacher.savedMovies = cachedMovies

        // When
        sut.isOffline = true

        // Simulate going offline
        sut.testLoadFromCache()

        // Then
        XCTAssertEqual(sut.moviesArray.count, 1)
        XCTAssertEqual(sut.moviesArray.first?.title, "Cached Movie")
    }

    // MARK: - Year Parsing

    func test_getYearFromDate_validDate_returnsYear() {
        let year = sut.testGetYearFromDate("2023-05-15")
        XCTAssertEqual(year, "2023")
    }

    func test_getYearFromDate_invalidDate_returnsEmpty() {
        let year = sut.testGetYearFromDate("invalid-date")
        XCTAssertEqual(year, "")
    }

    func test_getYearFromDate_emptyString_returnsEmpty() {
        let year = sut.testGetYearFromDate("")
        XCTAssertEqual(year, "")
    }
}
