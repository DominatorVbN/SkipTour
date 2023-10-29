//
//  MovieListView.swift
//
//
//  Created by Amit Samant on 29/10/23.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel: MovieListViewModel
    
    init(type: MovieListViewModel.MovieListType) {
        self._viewModel = StateObject<MovieListViewModel>(
            wrappedValue: MovieListViewModel(type: type)
        )
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.results, id: \.id) { movie in
                NavigationLink(value: movie) {
                    MoviewListRowView(movie: movie)
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
                    .navigationTitle(movie.title ?? "NA")
            }
            .navigationTitle(viewModel.type.rawValue.capitalized)
        }
        .task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        await viewModel.fetch()
    }
    
}
