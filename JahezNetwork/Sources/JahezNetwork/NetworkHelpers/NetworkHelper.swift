//
//  NetworkHelper.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import Foundation
import Combine

class NetworkHelper {
    enum HTTPHeaderField: String {
        case contentType = "Content-Type"
    }
    static func getHeaders() -> [String: String] {
            let headers = [
                HTTPHeaderField.contentType.rawValue: "application/json"
            ]
            return headers
    }
}
