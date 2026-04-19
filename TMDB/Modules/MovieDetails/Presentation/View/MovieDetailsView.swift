//
//  MovieDetailsView.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import SwiftUI
import JahezDesign

// MARK: - MovieDetailsView
struct MovieDetailsView: View {
    
    // MARK: Dependencies
    @StateObject var viewModel: MovieDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Init
    init(viewModel: MovieDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Helpers
    private var formattedReleaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: viewModel.movieDetails.releaseDate) else { return viewModel.movieDetails.releaseDate }
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private var formattedBudget: String {
        viewModel.movieDetails.budget == 0 ? "N/A" : "$\(viewModel.movieDetails.budget.formatted())"
    }
    
    private var formattedRevenue: String {
        viewModel.movieDetails.revenue == 0 ? "N/A" : "$\(viewModel.movieDetails.revenue.formatted())"
    }
    
    private var formattedRuntime: String {
        viewModel.movieDetails.runtime == 0 ? "N/A" : "\(viewModel.movieDetails.runtime) min"
    }
    
    // MARK: - Body
    public var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.05, green: 0.05, blue: 0.05)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    backdropSection
                    contentSection
                }
            }
            .ignoresSafeArea(edges: .top)
            
            navBar
        }
        .onAppear { viewModel.callGetMovieDetails() }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Backdrop
    private var backdropSection: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                MovieAsyncImage(url: viewModel.movieDetails.backdropURL)
                    .frame(width: geo.size.width, height: 320)
                    .clipped()
            }
            
            LinearGradient(
                colors: [.clear, Color(red: 0.05, green: 0.05, blue: 0.05)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 120)
        }
        .frame(height: 320)
    }
    
    // MARK: - Content
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleRow
            Divider().background(Color.white.opacity(0.1))
            overviewSection
            infoGrid
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }
    
    // MARK: Title Row (poster + title + genres)
    private var titleRow: some View {
        HStack(alignment: .top, spacing: 14) {
            // Small poster thumbnail
            MovieAsyncImage(url: viewModel.movieDetails.posterURL)
                .frame(width: 70, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\(viewModel.movieDetails.title) (\(formattedReleaseDate))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(viewModel.movieDetails.genres.joined(separator: ", "))
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.top, 4)
    }
    
    // MARK: Overview
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.movieDetails.overview)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: Info Grid
    private var infoGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider().background(Color.white.opacity(0.1))
                .padding(.bottom, 12)
            
            if !viewModel.movieDetails.homepage.isEmpty {
                homepageRow
            }
            
            infoCell(label: "Languages", value: viewModel.movieDetails.spokenLanguages.joined(separator: ", "))
            
            infoRow(
                left: ("Status", viewModel.movieDetails.status),
                right: ("Runtime", formattedRuntime)
            )
            
            infoRow(
                left: ("Budget", formattedBudget),
                right: ("Revenue", formattedRevenue)
            )
        }
    }
    
    // MARK: Homepage
    private var homepageRow: some View {
        HStack(spacing: 5) {
            Text("Homepage:")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
            
            Link(viewModel.movieDetails.homepage, destination: URL(string: viewModel.movieDetails.homepage) ?? URL(string: "https://")!)
                .font(.system(size: 13))
                .foregroundColor(Color(red: 1.0, green: 0.82, blue: 0.14))
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
    
    // MARK: Nav Bar
    private var navBar: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

extension MovieDetailsView {
    @ViewBuilder
    private func infoRow(
        left: (String, String?),
        right: (String, String?)
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            infoCell(label: left.0, value: left.1)
            Spacer()
            infoCell(label: right.0, value: right.1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private func infoCell(label: String, value: String?) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            Text("\(label):")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
            
            if let value {
                Text(value)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
