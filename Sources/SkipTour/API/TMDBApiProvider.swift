//
//  TMDBApiProvider.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import Foundation
 
class TMDBApiProvider {
    
    enum RequestError: Error {
        case unableToCreate
        case dataNotFound
    }
    
    func fetchMovies(
        api: TMDBAPI
    ) async throws -> PaginatedMovieResponse {
        let request = try api.getURLRequest()
        NetworkLogger.log(request: request)
        let (data, response) = try await URLSession.shared.data(for: request)
        NetworkLogger.log(data: data, response: response, error: nil)
        let decodedData = try JSONDecoder().decode(PaginatedMovieResponse.self, from: data)
        return decodedData
    }

}
