//
//  NetworkClient.swift
//  TMDB
//
//  Created by Mohamed Sadek on 25/03/2026.
//

import Foundation
import Combine
import JahezUtilities

public protocol NetworkClientProtocol: AnyObject {
    func request<R: Codable>(request: URLRequest, mapToModel: R.Type) -> AnyPublisher<R, NetworkError>
}

public final class NetworkClient: NetworkClientProtocol {
    private var configuration: URLSessionConfiguration
    private var session: URLSession
    
    public init(configuration: URLSessionConfiguration, session: URLSession) {
        self.configuration = configuration
        self.session = session
    }
    
    
    public func request<R: Codable>(request: URLRequest, mapToModel: R.Type) -> AnyPublisher<R, NetworkError> {
        print("[\(request.httpMethod?.uppercased() ?? "")] '\(request.url!)'")
        Log.info(request.httpMethod?.description ?? "")
        Log.info(request.url?.description ?? "")
        Log.info(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")
        return session.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.requestFailed
                }
                if (200..<300) ~= httpResponse.statusCode {
                    Log.info("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
                    Log.info(String(data: result.data, encoding: .utf8) ?? "")
                    return result.data
                } else if httpResponse.statusCode == 401 {
                    Log.error("Unauthorithed  error with code 401: ================ ")
                    throw NetworkError.unAuthorithed
                } else {
                        Log.error("Something went wrong error: ================ ")
                        Log.error("with status code \(httpResponse.statusCode.description)")
                        throw NetworkError.emptyErrorWithStatusCode(httpResponse.statusCode.description)
                }
            }
            .receive(on: DispatchQueue.main)
            .decode(type: R.self, decoder: JSONDecoder())
            .mapError({ error -> NetworkError in
                if let error = error as? NetworkError {
                    return error
                }
                Log.error("Normal error")
                Log.error("Decode error")
                if let decodingError = error as? Swift.DecodingError {
                    switch decodingError {
                    case .typeMismatch(let key, let value):
                        Log.error("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    default: break
                    }
                }
                Log.error(error.localizedDescription)
                return NetworkError.normalError(error)
            })
            .eraseToAnyPublisher()
    }
}
