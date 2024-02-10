//
//  DetailRequest.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation
import Moya

let detailProvider = BaseMoyaProvider<DetailRequest>(
    plugins: [
        NetworkLoggerPlugin(
            configuration: .init(
                formatter: .init(responseData: JSONResponseDataFormatter),
                logOptions: .verbose
            )
        ),
    ]
)

enum DetailRequest {
    case getDetail(id: Int)
    case getImages(id: Int)
}

extension DetailRequest: TargetType {
    var baseURL: URL { URL(string: ApiConstant.Base.BaseUrl)! }

    var method: Moya.Method { .get }

    var path: String {
        switch self {
        case let .getDetail(id):
            return ApiConstant.DetailPath.detail + "/\(id)"
        case let .getImages(id):
            return ApiConstant.DetailPath.detail + "/\(id)/" + ApiConstant.DetailPath.images
        }
    }

    var task: Moya.Task {
        switch self {
        case let .getDetail(id):
            var params = [String: Any]()
            params["movie_id"] = id
            params["append_to_response"] = "similar,videos,credits"
            params["language"] = "en-US"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getImages:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return Auth.auth
    }
}
