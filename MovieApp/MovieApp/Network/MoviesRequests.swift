//
//  MoviesRequests.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation
import Moya

/**
    A function to format JSON response data into a human-readable string.
    
    - Parameter data: The data to be formatted.
    - Returns: A string representation of the formatted JSON data.
*/
func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

/**
    A provider for making network requests related to movie lists.

    This provider is configured with a `NetworkLoggerPlugin` for logging network requests and responses.
*/
let movieListProvider = BaseMoyaProvider<MovieList>(
    plugins: [
        NetworkLoggerPlugin(
            configuration: .init(
                formatter: .init(responseData: JSONResponseDataFormatter),
                logOptions: .verbose
            )
        )
    ]
)

/// Enum representing different types of movie list requests.
enum MovieList {
    case nowPlaying(page : Int)
    case getPopular(page: Int)
    case getTopRated(page: Int)
    case upcoming(page: Int)
}

extension MovieList: TargetType {
    
    /// The base URL for movie list requests.
    var baseURL: URL { URL(string: ApiConstant.Base.BaseUrl)! }
    
    /// The HTTP method used for the request.
    var method: Moya.Method { .get }
    
    /// The path component of the request URL.
    var path: String {
        switch self {
        case .nowPlaying:
            return ApiConstant.MovieListPath.popular
        case .getPopular:
            return ApiConstant.MovieListPath.popular
        case .getTopRated:
            return ApiConstant.MovieListPath.topRated
        case .upcoming:
            return ApiConstant.MovieListPath.upcoming
        }
    }
    
    /// The task to be performed.
    var task: Moya.Task {
        switch self {
        case .getPopular(let page), .getTopRated(let page), .upcoming(let page) , .nowPlaying(let page):
            var params = [String: Any]()
            params[""] = "en-US"
            params["page"] = page
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    /// The headers to be included in the request.
    var headers: [String: String]? { Auth.auth }
}
