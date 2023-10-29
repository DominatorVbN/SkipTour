//
//  NetworkLogger.swift
//  ElegantAPI
//
//  Created by dominator on 02/05/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation
import OSLog

/// Utiliy class to log network events
open class NetworkLogger {
    
    static let networkLogger: Logger = Logger(subsystem: "in.amitsamant.elegantapi", category: "network")
    
    /// Log's the outgoing url request
    /// - Parameter request: Request to be logged
    public class func log(request: URLRequest){
        let urlString = request.url?.absoluteString ?? ""
        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            let fallBackString = String(data: body, encoding: .utf8) ?? "Can't render body; not utf8 encoded"
            let bodyString = try? body.prettyPrintedJSONString()
            requestLog += "\n\(bodyString ?? fallBackString)\n"
        }

        requestLog += "\n------------------------->\n";
        networkLogger.info("\(requestLog)")
    }
    
    /// Log's the recieved server response
    /// - Parameters:
    ///   - data: Data coming from serevr
    ///   - response: Response coming from serevr
    ///   - error: Error coming from serevr
    public class func log(data: Data?, response: URLResponse?, error: Error?){
        let url = response?.url
        let urlString = url?.absoluteString ?? ""
        var responseLog = "\n---------- IN ---------->\n"
        responseLog += "\(urlString)"
        responseLog += "\n\n"
        
        #if !SKIP
        let path: String = url?.path() ?? ""
        let query: String = url?.query() ?? ""
        
        if let httpResponse = response as? HTTPURLResponse{
            responseLog += "HTTP \(httpResponse.statusCode) \(path)?\(query)\n"
        }
        
        let host: String = url?.host() ?? ""
        responseLog += "Host: \(host)\n"
        
        for (key,value) in (response as? HTTPURLResponse)?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        
        #endif
        
        if let body = data {
            let bodyString = (try? body.prettyPrintedJSONString()) ?? (String(data: body, encoding: .utf8) ?? "Can't render body; not utf8 encoded")
            responseLog += "\n\(bodyString)\n"
        }
        
        #if !SKIP
        responseLog += "\nError: \(String(describing: error))\n"
        #endif

        responseLog += "\n<------------------------\n";
        networkLogger.info("\(responseLog)")
    }
    
}

public extension Data {
    /// Formats the data in indented style
    func prettyPrintedJSONString() throws -> String {
        let object = try JSONSerialization.jsonObject(with: self, options: [])
        let data = try JSONSerialization.data(withJSONObject: object, options: [JSONSerialization.WritingOptions.prettyPrinted])
        let prettyPrintedString = String(data: data, encoding: .utf8)
        return prettyPrintedString!
    }
}
