//
//  URLRequest+.swift
//  ElegantAPI
//
//  Created by dominator on 16/04/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

enum URLRequestQueryError: String, Error {
    case urlQueryError
    case absentURL
}

public extension URLRequest {
    
    /// Adds parameter as url queries
    /// - Parameter parameters: parameter to encode
    mutating func addURLQuery(parameter: [String: Any]) throws{
        guard let url = self.url else { throw URLRequestQueryError.absentURL }
        var urlString = url.absoluteString
        if !parameter.isEmpty {
            urlString += "?"
            
            for (key, value) in parameter {
                let strValue = "\(value)"
                let encodedKey = key
                let encodedValue = strValue
                urlString += "\(encodedKey)=\(encodedValue)&"
            }
            
            // Remove the trailing '&' character
            urlString = String(urlString.dropLast())
        }
        
        guard let updatedUrl = URL(string: urlString) else { throw URLRequestQueryError.urlQueryError }
        self.url = updatedUrl
    }
    
    /// Update the request to have multipart data
    /// - Parameter array: Array of mutipart data to be added
    mutating func addMultipart(multipart array: [MultipartFormData]){
        let boundary = "Boundary-\(UUID().uuidString)"
        self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var httpBody = Data()
        for element in array{
            if let fileName = element.fileName,let mimeType = element.mimeType{
                httpBody.append(convertFileData(fieldName: element.name, fileName: fileName, mimeType: mimeType, fileData: element.data, using: boundary))
            }else{
                httpBody.append(convertFormField(named: element.name, value: element.data, using: boundary))
            }
        }
        self.httpBody = httpBody
    }
    
    /// Creates data in formate of form data specification
    /// - Parameters:
    ///   - name: Name of field
    ///   - value: Value of field
    ///   - boundary: Data boundary of field
    /// - Returns: returns the formatted Data object
    func convertFormField(named name: String, value: Data, using boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        data.append(value)
        data.append("\r\n".data(using: .utf8)!)
        return data as Data
    }
    
    /// Creates data in format of content desposition (mutipart file upload) specification
    /// - Parameters:
    ///   - fieldName: Name of field
    ///   - fileName: File name
    ///   - mimeType: File's mime type
    ///   - fileData: File's content
    ///   - boundary: Data boundary of field
    /// - Returns: returns the formatted data
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        return data as Data
    }
}
