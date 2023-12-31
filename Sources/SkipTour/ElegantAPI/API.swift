//
//  API.swift
//  ElegantAPI
//
//  Created by dominator on 16/04/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation
import Combine

/// The protocol used to define the specifications necessary for a genarting an URLRequest
///  Some additional content
///  This protocol is intented to be implemented by an enum whoose cases reperesnt each endpoint of the api calls you want to make, and provide the requirement according to each case.
public protocol API {
    
    /// The request's base `URL`.
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: Method { get }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { get }
    
    /// The type of HTTP task to be performed.
    var task: Task { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// Genrates URLRequest combining all the properties of API protocol
    /// - Returns: Genrated URLRequest
    func getURLRequest() throws -> URLRequest
}

public extension API{
    func getURLRequest() throws -> URLRequest {
        let fullURL = baseURL.appendingPathComponent(self.path)
        var urlRequest = URLRequest(url: fullURL)
        
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = self.headers
        switch self.task {
        case .requestData(let data):
            urlRequest.httpBody = data
        case .requestJSONEncodable(let value):
            do {
                let data = try value.toJSONData()
                urlRequest.httpBody = data
            } catch {
                throw error
            }
        case .requestCompositeData(let bodyData,let urlParameters):
            try urlRequest.addURLQuery(parameter: urlParameters)
            urlRequest.httpBody = bodyData
        case .requestCompositeParameters(let bodyParameters,let bodyEncoding,let urlParameters):
            try urlRequest.addURLQuery(parameter: urlParameters)
            switch bodyEncoding {
            case ParameterEncoding.JSONEncoded:
                do {
                    let data = try JSONSerialization.data(withJSONObject: bodyParameters, options: JSONSerialization.WritingOptions.prettyPrinted)
                    urlRequest.httpBody = data
                } catch{
                    throw error
                }
            case ParameterEncoding.URLEncoded:
                try urlRequest.addURLQuery(parameter: bodyParameters)
            }
        case .requestPlain:
            break
        case .requestCustomJSONEncodable(let body, let encoder):
            do{
                let data = try body.toJSONData(encoder)
                urlRequest.httpBody = data
            }catch{
                throw error
            }
        case .requestParameters(let parameters, let encoding):
            switch encoding {
            case ParameterEncoding.URLEncoded:
                try urlRequest.addURLQuery(parameter: parameters)
            case ParameterEncoding.JSONEncoded:
                do{
                    let data = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
                    urlRequest.httpBody = data
                }catch{
                    throw error
                }
            }
        case .uploadMultipart(let array):
            urlRequest.addMultipart(multipart: array)
        case .uploadCompositeMultipart(let array,let urlParameters):
            urlRequest.addMultipart(multipart: array)
            try urlRequest.addURLQuery(parameter: urlParameters)
        }
        return urlRequest
    }
    

}
