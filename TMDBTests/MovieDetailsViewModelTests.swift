//
//  MovieDetailsViewModelTests.swift
//  TMDBTests
//
//  Created by Mohamed Sadek on 19/04/2026.
//


import XCTest
import Combine
import JahezNetwork
import JahezUtilities
@testable import TMDB
 
// MARK: - Mock
 
final class MockMovieDetailsUseCase: MovieDetailsUseCaseProtocol {
    var result: Result<MovieDetailsResponseModel, NetworkError> = .success(.mock())

    func getMovieDetails(request: MovieDetailsRequestModel, movieId: Int) -> AnyPublisher<MovieDetailsResponseModel, NetworkError> {
        switch result {
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
 
// MARK: - Helpers
 
extension MovieDetailsResponseModel {
    static func mock(
        id: Int = 1,
        title: String = "Inception",
        overview: String = "A thief who steals corporate secrets.",
        releaseDate: String = "2010-07-16",
        genres: [GenreDetails] = [GenreDetails(id: 28, name: "Action")],
        budget: Int = 160_000_000,
        revenue: Int = 836_000_000,
        runtime: Int = 148,
        status: String = "Released",
        homepage: String = "https://inception.com",
        spokenLanguages: [SpokenLanguage] = [SpokenLanguage(englishName: "English", iso639_1: "en", name: "English")],
        posterPath: String = "/poster.jpg",
        backdropPath: String = "/backdrop.jpg"
    ) -> MovieDetailsResponseModel {
        MovieDetailsResponseModel(
            adult: false,
            backdropPath: backdropPath,
            belongsToCollection: nil,
            budget: budget,
            genres: genres,
            homepage: homepage,
            id: id,
            imdbID: "tt1375666",
            originCountry: ["US"],
            originalLanguage: "en",
            originalTitle: title,
            overview: overview,
            popularity: 100.0,
            posterPath: posterPath,
            productionCompanies: nil,
            productionCountries: nil,
            releaseDate: releaseDate,
            revenue: revenue,
            runtime: runtime,
            spokenLanguages: spokenLanguages,
            status: status,
            tagline: nil,
            title: title,
            video: false,
            voteAverage: 8.8,
            voteCount: 35000
        )
    }
}
 
extension Result where Failure == NetworkError {
    var publisher: AnyPublisher<Success, Failure> {
        switch self {
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
 
// MARK: - Tests
 
final class MovieDetailsViewModelTests: XCTestCase {
 
    var sut: MovieDetailsViewModel!
    var mockUseCase: MockMovieDetailsUseCase!
    var cancellables: Set<AnyCancellable> = []
 
    override func setUp() {
        super.setUp()
        mockUseCase = MockMovieDetailsUseCase()
        sut = MovieDetailsViewModel(
            movieDetailsUseCase: mockUseCase,
            passedMovieId: 1
        )
    }
 
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellables = []
        super.tearDown()
    }
 
    // MARK: - Init
 
    func test_init_setsPassedMovieId() {
        let vm = MovieDetailsViewModel(movieDetailsUseCase: mockUseCase, passedMovieId: 42)
        XCTAssertEqual(vm.sentMovieId, 42)
    }
 
    func test_init_movieDetailsIsEmpty() {
        XCTAssertEqual(sut.movieDetails.title, "")
        XCTAssertEqual(sut.movieDetails.id, 0)
    }
 
    // MARK: - Success
 
    func test_getMovieDetails_success_populatesMovieDetails() {
        // Given
        mockUseCase.result = .success(.mock(id: 1, title: "Inception"))
 
        let expectation = expectation(description: "movie details loaded")
        sut.$movieDetails
            .dropFirst()
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
 
        // When
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        // Then
        XCTAssertEqual(sut.movieDetails.title, "Inception")
        XCTAssertEqual(sut.movieDetails.id, 1)
    }
 
    func test_getMovieDetails_success_mapsGenresCorrectly() {
        // Given
        let genres = [GenreDetails(id: 28, name: "Action"), GenreDetails(id: 12, name: "Adventure")]
        mockUseCase.result = .success(.mock(genres: genres))
 
        let expectation = expectation(description: "genres mapped")
        sut.$movieDetails.dropFirst().first().sink { _ in expectation.fulfill() }.store(in: &cancellables)
 
        // When
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        // Then
        XCTAssertEqual(sut.movieDetails.genres, ["Action", "Adventure"])
    }
 
    func test_getMovieDetails_success_mapsReleaseDateCorrectly() {
        // Given
        mockUseCase.result = .success(.mock(releaseDate: "2010-07-16"))
 
        let expectation = expectation(description: "release date mapped")
        sut.$movieDetails.dropFirst().first().sink { _ in expectation.fulfill() }.store(in: &cancellables)
 
        // When
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        // Then
        XCTAssertEqual(sut.movieDetails.releaseDate, "2010-07-16")
    }
 
    func test_getMovieDetails_success_mapsBudgetAndRevenue() {
        // Given
        mockUseCase.result = .success(.mock(budget: 160_000_000, revenue: 836_000_000))
 
        let expectation = expectation(description: "budget and revenue mapped")
        sut.$movieDetails.dropFirst().first().sink { _ in expectation.fulfill() }.store(in: &cancellables)
 
        // When
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        // Then
        XCTAssertEqual(sut.movieDetails.budget, 160_000_000)
        XCTAssertEqual(sut.movieDetails.revenue, 836_000_000)
    }
 
    func test_getMovieDetails_success_mapsSpokenLanguages() {
        // Given
        let languages = [
            SpokenLanguage(englishName: "English", iso639_1: "en", name: "English"),
            SpokenLanguage(englishName: "French", iso639_1: "fr", name: "Français")
        ]
        mockUseCase.result = .success(.mock(spokenLanguages: languages))
 
        let expectation = expectation(description: "languages mapped")
        sut.$movieDetails.dropFirst().first().sink { _ in expectation.fulfill() }.store(in: &cancellables)
 
        // When
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        // Then
        XCTAssertEqual(sut.movieDetails.spokenLanguages.count, 2)
        XCTAssertTrue(sut.movieDetails.spokenLanguages.contains("English"))
    }
 
    func test_getMovieDetails_success_mapsRuntimeAndStatus() {
        // Given
        mockUseCase.result = .success(.mock(runtime: 148, status: "Released"))
 
        let expectation = expectation(description: "runtime and status mapped")
        sut.$movieDetails.dropFirst().first().sink { _ in expectation.fulfill() }.store(in: &cancellables)
 
        // When
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        // Then
        XCTAssertEqual(sut.movieDetails.runtime, 148)
        XCTAssertEqual(sut.movieDetails.status, "Released")
    }
 
    func test_getMovieDetails_success_isLoadingBecomeFalse() {
        // Given
        mockUseCase.result = .success(.mock())
 
        let expectation = expectation(description: "loading finished")
        sut.$isLoading
            .filter { !$0 }
            .dropFirst()
            .first()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
 
        // When
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        // Then
        XCTAssertFalse(sut.isLoading)
    }
 
    // MARK: - Failure
 
    func test_getMovieDetails_failure_isLoadingBecomeFalse() {
        // Given
        mockUseCase.result = .failure(.requestFailed)
 
        // When
        sut.callGetMovieDetails()
 
        // Then
        XCTAssertFalse(sut.isLoading)
    }
 
    func test_getMovieDetails_failure_movieDetailsRemainsEmpty() {
        // Given
        mockUseCase.result = .failure(.decodeFailed)
 
        // When
        sut.callGetMovieDetails()
 
        // Then
        XCTAssertEqual(sut.movieDetails.title, "")
        XCTAssertEqual(sut.movieDetails.id, 0)
    }
 
    // MARK: - Mapping Edge Cases
 
    func test_toDetails_zeroBudget_remainsZero() {
        mockUseCase.result = .success(.mock(budget: 0))
 
        let expectation = expectation(description: "loaded")
        sut.$movieDetails.dropFirst().first().sink { _ in expectation.fulfill() }.store(in: &cancellables)
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        XCTAssertEqual(sut.movieDetails.budget, 0)
    }
 
    func test_toDetails_emptyGenres_returnsEmptyArray() {
        mockUseCase.result = .success(.mock(genres: []))
 
        let expectation = expectation(description: "loaded")
        sut.$movieDetails.dropFirst().first().sink { _ in expectation.fulfill() }.store(in: &cancellables)
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        XCTAssertTrue(sut.movieDetails.genres.isEmpty)
    }
 
    func test_toDetails_emptyHomepage_remainsEmpty() {
        mockUseCase.result = .success(.mock(homepage: ""))
 
        let expectation = expectation(description: "loaded")
        sut.$movieDetails.dropFirst().first().sink { _ in expectation.fulfill() }.store(in: &cancellables)
        sut.callGetMovieDetails()
        waitForExpectations(timeout: 1)
 
        XCTAssertEqual(sut.movieDetails.homepage, "")
    }
}
