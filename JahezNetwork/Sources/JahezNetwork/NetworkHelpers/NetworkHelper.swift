//
//  NetworkHelper.swift
//  TMDB
//
//  Created by Mohamed Sadek on 26/03/2026.
//

import Foundation
import Combine
import JahezUtilities

public class NetworkHelper {
    enum HTTPHeaderField: String {
        case accept = "accept"
        case authorization = "Authorization"
    }
    public static func getHeaders() -> [String: String] {
            let headers = [
                HTTPHeaderField.accept.rawValue: "application/json",
                HTTPHeaderField.authorization.rawValue : "Bearer \(Constants.authorizationToken)"
                
            ]
            return headers
    }
}
