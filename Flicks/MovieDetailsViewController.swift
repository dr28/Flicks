//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Deepthy on 9/13/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieDetailsScroll: UIScrollView!

    @IBOutlet weak var movieDetailsView: UIView!

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    @IBOutlet weak var voteAvgLabel: UILabel!
    
    @IBOutlet weak var voteAvgImg: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    @IBOutlet weak var largePosterImage: UIImageView!
    
    var movie: Movie?
    
    var smallPosterUrl :URL!
    var largePosterUrl :URL!
    override func viewDidLoad() {
        super.viewDidLoad()

        let contentWidth = movieDetailsScroll.bounds.width
        let contentHeight = movieDetailsScroll.bounds.height + 1
        movieDetailsScroll.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        let newOffset = CGPoint.init(x: movieDetailsScroll.contentOffset.x, y: movieDetailsScroll.contentOffset.y)
        movieDetailsScroll.setContentOffset(newOffset, animated: true)

        self.tabBarController?.tabBar.items?[0].isEnabled = false
        self.tabBarController?.tabBar.items?[1].isEnabled = false
        
        let votingImageFromFile :UIImage = UIImage.init(named: "Star_filled")!
        let votingImgView = UIImageView.init(image: votingImageFromFile.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        votingImgView.tintColor = UIColor.white
        voteAvgImg.image = votingImgView.image

        movieDetailsView.alpha = 0.7
        
        
        if let path = movie?.moviePosterPath
        {
            smallPosterUrl = URL(string: Constants.smallImgBaseUrl + path)
            largePosterUrl = URL(string: Constants.originalImgBaseUrl + path)
            loadLowToHighResImage()

        }
        
        movieTitleLabel.text = movie?.movieTitle
        releaseDateLabel.text = movie?.movieReleaseDate
        voteAvgLabel.text =  movie?.movieVoteAvg
        overviewLabel.text = movie?.movieOveriew
        overviewLabel.sizeToFit()
        
    }
    
    private func loadLowToHighResImage() {

        let smallPosterRequest = URLRequest(url: smallPosterUrl!)

        largePosterImage.setImageWith(
            smallPosterRequest,
            placeholderImage: nil,
            success: { (smallImgReq, smallImgResponse, smallImage) in
                self.largePosterImage.image = smallImage
                if smallImgResponse != nil {
                    self.largePosterImage.alpha = 0.0
                    UIView.animate(withDuration: 0.4, animations: {
                        self.largePosterImage.alpha = 1.0
                    }, completion: { (success) in
                        DispatchQueue.main.async {
                            self.highResImage(placeholder: smallImage)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        self.highResImage(placeholder: smallImage)
                    }
                }
       
        }, failure: { (request, response, error) in
        
            // do something for the failure condition of the large image request
            // possibly setting the ImageView's image to a default image
            
            self.highResImage(placeholder: nil)
        })
    }
    
    private func highResImage(placeholder: UIImage?) {
        let largePosterRequest = URLRequest(url: largePosterUrl!)
        
        largePosterImage.setImageWith(
            largePosterRequest,
            placeholderImage: placeholder,
            success: { (largeRequest, largeResponse, largeImage) in
                self.largePosterImage.image = largeImage
                if largeResponse != nil && placeholder == nil {
                    self.largePosterImage.alpha = 0.0
                    UIView.animate(withDuration: 0.4, animations: {
                        self.largePosterImage.alpha = 1.0
                    })
                }
        }) { (request, reponse, error) in
            print("Error getting Img \(error.localizedDescription)")
            self.largePosterImage.image = placeholder
        }
    }

    
}
