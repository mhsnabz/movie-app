//
//  MovieListModel.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation

// MARK: - MovieListModel

struct MovieListModel: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?
    var type: String?
    enum CodingKeys: String, CodingKey {
        case page, results, type, dates
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    mutating func setType(type: String) {
        self.type = type
    }
}

// MARK: - Dates

struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Result

struct Result: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

//similar//videos//images//credits
