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
        ),
    ]
)

/// Enum representing different types of movie list requests.
enum MovieList {
    case nowPlaying(page: Int)
    case getPopular(page: Int)
    case getTopRated(page: Int)
    case upcoming(page: Int)
    case getSortedMovies(genres: [GenreTitle]?, sortyBy: MoviesSortEnum = .popular_asc, date: String? = nil, page: Int = 1)
    case getSimilarMovies(page: Int, movieId: Int)
    case search(query : String)
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
            return ApiConstant.MovieListPath.nowPlaying
        case .getPopular:
            return ApiConstant.MovieListPath.popular
        case .getTopRated:
            return ApiConstant.MovieListPath.topRated
        case .upcoming:
            return ApiConstant.MovieListPath.upcoming
        case .getSortedMovies:
            return ApiConstant.SortMoviePath.path
        case let .getSimilarMovies(_, movieId):
            return String(format: ApiConstant.MovieListPath.similar, movieId)
        case .search:
            return ApiConstant.SearchMoviewPath.search
        }
    }

    /// The task to be performed.
    var task: Moya.Task {
        switch self {
        case let .getPopular(page), let .getTopRated(page), let .upcoming(page), let .nowPlaying(page), let .getSimilarMovies(page, _):
            var params = [String: Any]()
            params[""] = "en-US"
            params["page"] = page
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case let .getSortedMovies(genres, sortyBy, date, page):
            var params = [String: Any]()
            var genre: String = ""
            if let genres {
                genres.forEach { element in
                    genre = genre + "," + String(element.id)
                }
                let index = genre.index(genre.startIndex, offsetBy: 0)
                genre.remove(at: index)
                params["with_genres"] = genre
            }

            if let date {
                params["primary_release_date.gte"] = date
            } else {
                params["sort_by"] = sortyBy.rawValue
            }
            params["include_video"] = false
            params["include_adult"] = false
            params["language"] = "en-US"
            params["page"] = page
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .search(query: let query):
            var params = [String: Any]()
            params[""] = "en-US"
            params["query"] = query
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    /// The headers to be included in the request.
    var headers: [String: String]? { Auth.auth }
}

enum MoviesSortEnum: String {
    case popular_desc = "popularity.desc"
    case popular_asc = "popularity.asc"
    case vote_asc = "vote_average.asc"
    case vote_desc = "vote_count.desc"
    case relase_date_desc = "primary_release_date.desc"
    case relase_date_asc = "primary_release_date.asc"
    case primary_release_date_gte = "primary_release_date.gte"
}
