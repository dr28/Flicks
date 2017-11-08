//
//  MovieCell.swift
//  Flicks
//
//  Created by Deepthy on 9/13/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    var movie: Movie? {
        didSet {
            nameLabel.text = movie?.movieTitle
            synopsisLabel.text = movie?.movieOveriew
            synopsisLabel.sizeToFit()
            
            if let path = movie?.moviePosterPath {
                Constants.getImage(path: path, posterView: posterView)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
