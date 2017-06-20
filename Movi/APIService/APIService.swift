//
//  APIService.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxDataSources

fileprivate let apiKey = ""

struct APIResultListState<Item> {
    var loadedItems: [Item]
    var currentPage: Int
}

enum APIService {
    case getMovies(page: Int)
    case getMovie(id: Int)
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
        case .getMovie(let id):
            return "/movie/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMovies, .getMovie:
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
        case .getMovie:
            return [
                "api_key": apiKey
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        return .request
    }
    
    var sampleData: Data {
        switch self {
        case .getMovies:
            return "{}".data(using: .utf8)!
        case .getMovie:
            return "{}".data(using: .utf8)!
        }
        
    }
}

extension APIService {
    static let emptyListResult = APIResultListState<Movie>(loadedItems: [], currentPage: 1)
}
