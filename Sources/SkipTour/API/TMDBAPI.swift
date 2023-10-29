//
//  TMDBAPI.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import Foundation


enum TMDBAPI {
    case trending
    case discover
}

// Provider and Keys
extension TMDBAPI {
    static let provider = TMDBApiProvider()
    private static let apiKey = "d6bc218c10cb73c14b35b5a648f929ed"
}

extension TMDBAPI: API {

    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .discover:
            return "discover/movie"
        case .trending:
            return "trending/all/day"
        }
    }
    
    var method: Method {
        switch self {
        case .trending, .discover:
            return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .trending:
            return .requestParameters(
                parameters: [
                    "api_key": TMDBAPI.apiKey,
                    "language": "en-US",
                    "page": 1
                ],
                encoding: .URLEncoded
            )
        case .discover:
            return .requestParameters(
                parameters: [
                    "api_key": TMDBAPI.apiKey,
                    "language": "en-US",
                    "page": 1
                ],
                encoding: .URLEncoded
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .trending, .discover:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        }
    }
}
