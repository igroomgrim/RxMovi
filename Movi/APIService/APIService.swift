//
//  APIService.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import Foundation
import Moya

fileprivate let apiKey = ""

enum APIService {
    case getMovies(page: Int64)
}

extension APIService: TargetType {
    var baseURL: URL {
        let version = 3
        return URL(string: "https://api.themoviedb.org/\(version)")!
    }
    
    var path: String {
        switch self {
        case .getMovies:
            return "/discover/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMovies:
            return .get

        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getMovies(let page):
            return [
                "page": page,
                "api_key": apiKey,
                "sort_by": "release_date.desc"
            ]
        }
    }
    
    var task: Task {
        return .request
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var sampleData: Data {
        switch self {
        case .getMovies:
            return "{}".data(using: .utf8)!
        }
    }
    
    
}
