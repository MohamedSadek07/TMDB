//
//  NetworkRequest.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

import Foundation

protocol NetworkRequest {
  var baseURL: String { get  }
  var endPoint: String { get }
  var headers: [String: String]? { get }
  var queryParams: [String: Any]? { get }
  var parameters: [String: Any]? { get }
  var method: APIHTTPMethod { get }
}

extension NetworkRequest {
    var makeRequest: URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else { return URLRequest(url: URL(string: "") ?? URL(fileURLWithPath: "")) }
        urlComponents.path = "\(urlComponents.path)\(endPoint)"
        
        if let queryParams = queryParams {
            urlComponents.queryItems = self.addQueryItems(queryParams: queryParams)
        }
        guard let url = urlComponents.url else { return URLRequest(url: URL(string: baseURL)!) }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers = headers {
            _ = headers.map({
                request.addValue($0.value, forHTTPHeaderField: "\($0.key)")}
            )
        }
        if let params = parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        }
        return request
    }

    private func addQueryItems(queryParams: [String: Any]) -> [URLQueryItem] {
        return queryParams.map { key, value in
            if let arrayValue = value as? [Any] {
                // If the value is an array, format it as a comma-separated string
                let formattedValue = arrayValue.map { String(describing: $0) }.joined(separator: ",")
                return URLQueryItem(name: key, value: formattedValue)
            } else {
                // For non-array values, convert directly to a string
                return URLQueryItem(name: key, value: String(describing: value))
            }
        }
    }
}
