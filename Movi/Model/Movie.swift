//
//  Movie.swift
//  Movi
//
//  Created by Anak Mirasing on 6/18/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import Foundation
import ObjectMapper

class MoviesReponse: Mappable {
    var page: Int?
    var movies: Array<Movie>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page <- map["page"]
        movies <- map["results"]
    }
}

class Movie: Mappable {
    var voteCount: Int?
    var id: Int?
    var video: Bool?
    var voteAverage: Int?
    var title: String?
    var popularity: Double?
    var posterPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIds: Array<Int>?
    var backdropPath: String?
    var adult: Bool?
    var overview: String?
    var releaseDate: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        voteCount           <- map["vote_count"]
        id                  <- map["id"]
        video               <- map["video"]
        voteAverage         <- map["vote_average"]
        title               <- map["title"]
        popularity          <- map["popularity"]
        posterPath          <- map["poster_path"]
        originalLanguage    <- map["original_language"]
        originalTitle       <- map["original_title"]
        genreIds            <- map["genre_ids"]
        backdropPath        <- map["backdrop_path"]
        adult               <- map["adult"]
        overview            <- map["overview"]
        releaseDate         <- map["release_date"]
    }
}


class Genre: Mappable {
    var id: Int?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

class MovieDetail: Mappable {
    var title: String?
    var backdropPath: String?
    var posterPath: String?
    var synopsis: String?
    var genres: [Genre]?
    var originalLanguage: String?
    var duration: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        backdropPath <- map["backdrop_path"]
        posterPath <- map["poster_path"]
        synopsis <- map["overview"]
        genres <- map["genres"]
        originalLanguage <- map["original_language"]
        duration <- map["runtime"]
    }
}
