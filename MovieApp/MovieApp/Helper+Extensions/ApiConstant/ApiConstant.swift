//
//  ApiConstant.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation
struct ApiConstant{
    struct Base{
        static let BaseUrl = "https://api.themoviedb.org/3"
    }
    
    struct MovieListPath{
        static let nowPlaying = "movie/now_playing"
        static let popular = "movie/popular"
        static let topRated = "movie/top_rated"
        static let upcoming = "movie/upcoming"
    }
    
}

struct Auth{
    static let auth =  ["accept": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYmFhMTE5NjMwMWRhNDAwMWIxNzBmNzhiNGE3MTI3YiIsInN1YiI6IjY1YzRjN2E2MDIxY2VlMDE5Y2MzODY1MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fVHsfreZaMMQwCXLPsWQnkll7wcL3Dw6DOMYqxzfFL4"]
}
