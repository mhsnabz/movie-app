//
//  Genres.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]?
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}
