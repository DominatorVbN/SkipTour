//
//  MovieListViewModel.swift
//
//
//  Created by Amit Samant on 29/10/23.
//

import SwiftUI

class MovieListViewModel: ObservableObject {
    
    @Published var results: [Movie] = []
    
    enum MovieListType: String {
        case discover
        case trending
    }
    
    let type: MovieListType
    
    var apiEndPoint: TMDBAPI {
        switch type {
        case .discover:
            return .discover
        case .trending:
            return .trending
        }
    }
    
    init(type: MovieListViewModel.MovieListType) {
        self.type = type
    }
    
    @MainActor
    func fetch() async {
        do {
            self.results = try await TMDBAPI.provider.fetchMovies(api: apiEndPoint).results
        } catch {
            logger.error("results.error \(error)")
        }
    }
}
