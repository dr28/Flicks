//
//  Movie.swift
//  Flicks
//
//  Created by Deepthy on 9/16/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class Movie {

    private static let title = "title"
    private static let posterPath = "poster_path"
    private static let overview = "overview"
    private static let voteAvg = "vote_average"
    private static let releaseDate = "release_date"
    
    var movieTitle: String?
    var movieOveriew: String?
    var moviePosterPath: String?
    var movieVtAvg: Double!
    var movieReleaseDt: String?
    
    var movieReleaseDate: String? {
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateObj = dateFormatter.date(from: movieReleaseDt!)
            dateFormatter.dateFormat = "MMMM d, yyyy"
        
            return dateFormatter.string(from: dateObj!)
        }
        
        set(newValue) {
            movieReleaseDt = newValue
        }
    }
    
    var movieVoteAvg: String? {
        get {
            return String(format: "%.2f", movieVtAvg!).appending("%")
        }
    }
    
    init(data: [String: Any]) {
        movieTitle = data[Movie.title] as? String
        movieOveriew = data[Movie.overview] as? String
        moviePosterPath = data[Movie.posterPath] as? String
        movieVtAvg = data[Movie.voteAvg] as? Double ?? 0.0
        movieReleaseDt = data[Movie.releaseDate] as? String
    }
}
