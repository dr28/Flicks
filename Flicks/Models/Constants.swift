//
//  Constants.swift
//  Flicks
//
//  Created by Deepthy on 9/16/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

struct Constants {

    private static let baseURL = "https://api.themoviedb.org/3/movie"
    private static let nowPlayingEndpoint = "/now_playing?"
    private static let topRatedEndpoint = "/top_rated?"
    
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let smallImgBaseUrl = "http://image.tmdb.org/t/p/w45"
    static let originalImgBaseUrl = "http://image.tmdb.org/t/p/original"
    static let nowPlayingURL = baseURL + nowPlayingEndpoint + "api_key="+apiKey
    static let topRatedURL = baseURL + topRatedEndpoint + "api_key="+apiKey
    
    static let cellImgBaseUrl = "http://image.tmdb.org/t/p/w500"
    
    static let collectionReuseIdentifier = "collectioncell"
    static let tableReuseIdentifier = "tablecell"
    
    static let refreshControlTitle = "Pull to refresh"

    static func getImage(path: String, posterView: UIImageView) {

        //let cellImgBaseUrl = "http://image.tmdb.org/t/p/w500"
        let posterUrl = URL(string: cellImgBaseUrl + path)
        let posterRequest = URLRequest(url: posterUrl!)
        
        posterView.setImageWith(
            posterRequest,
            placeholderImage: nil,
            success: {
                (imageRequest, imageResponse, image) -> Void in
                    
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    posterView.alpha = 0.0
                    posterView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        posterView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    posterView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
                print("error in animation --->> \(error)")
        })
    }
}
