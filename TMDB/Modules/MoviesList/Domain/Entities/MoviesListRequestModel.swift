//
//  MoviesListRequestModel.swift
//  TMDB
//
//  Created by Mohamed Sadek on 19/04/2026.
//

struct MoviesListRequestModel: Encodable {
    let includeAdult: Bool
    let includeVideo: Bool
    let language: String
    let page: Int
    let sortBy: String
    
    enum CodingKeys: String, CodingKey {
        case includeAdult = "include_adult"
        case includeVideo = "include_video"
        case language
        case page
        case sortBy = "sort_by"
    }
}
