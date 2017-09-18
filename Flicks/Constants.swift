//
//  Constants.swift
//  Flicks
//
//  Created by Deepthy on 9/16/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

struct Constants {

    private static let baseURL = "https://api.themoviedb.org/3/"
    private static let nowPlayingEndpoint = "movie/now_playing?"
    private static let topRatedEndpoint = "discover/movie?"

    private static let filter = "&original_language=en&adult=false&primary_release_date.gte=2017-08-15&primary_release_date.lte=2017-09-14&sort_by=vote_average.desc"
        
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let smallImgBaseUrl = "http://image.tmdb.org/t/p/w45"
    static let originalImgBaseUrl = "http://image.tmdb.org/t/p/original"
    static let nowPlayingURL = baseURL + nowPlayingEndpoint + "api_key="+apiKey
    static let topRatedURL = baseURL + topRatedEndpoint + "api_key="+apiKey + filter
    
    static let cellImgBaseUrl = "http://image.tmdb.org/t/p/w500"
    
    static let collectionReuseIdentifier = "collectioncell"
    static let tableReuseIdentifier = "tablecell"
}
