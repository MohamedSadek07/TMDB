//
//  MoviesListView.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

import SwiftUI
import JahezDesign

struct MoviesListView: View {
    // MARK: Dependencies
    @StateObject var viewModel: MoviesListViewModel
    // MARK: - Init
    init(viewModel: MoviesListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.05)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Search bar
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 20)
                    
                    // Title
                    Text("Watch New Movies")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.yellow)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    
                    // Genre filter pills
                    genresSection()
                    
                    // Movies List
                    moviesSection()
                }
            }
        }
        .onAppear {
            viewModel.callViewRequests()
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
    }
}

extension MoviesListView {
    // Genre Horizontal Scrollable List
    private func genresSection() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                ForEach(viewModel.genresArray, id: \.id) { genre in
                    GenreCapsule(
                        title: genre.name ?? "",
                        isSelected: viewModel.selectedGenreId == genre.id
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedGenreId = genre.id ?? 0
                            viewModel.searchText = ""
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 18)
    }
    
    // Movie Grid
    @ViewBuilder
    private func moviesSection() -> some View {
        if viewModel.moviesArray.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "film.stack")
                    .font(.system(size: 40))
                    .foregroundStyle(.white.opacity(0.3))
                Text("No movies found")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        } else {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(viewModel.moviesArray) { movie in
                    MovieCardView(movie: movie)
                        .onAppear {
                            // Load more when last item appears
                            if movie.id == viewModel.moviesArray.last?.id {
                                viewModel.loadMoreMovies()
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            
            if viewModel.isLoadingMore {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.yellow)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 16)
            }
            Spacer()
        }
    }
}
