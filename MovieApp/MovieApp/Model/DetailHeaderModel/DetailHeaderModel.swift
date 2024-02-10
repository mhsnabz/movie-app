//
//  DetailHeaderModel.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation
struct DetailHeaderModel {
    let sourcePath: String?
    let type: ContentType?
}

enum ContentType {
    case image
    case video
}
