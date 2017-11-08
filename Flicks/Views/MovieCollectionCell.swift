//
//  MovieCollectionCell.swift
//  Flicks
//
//  Created by Deepthy on 9/13/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
        
    @IBOutlet weak var collectionCellImg: UIImageView!
    
    var movie: Movie? {
        didSet {            
            if let path = movie?.moviePosterPath {
                Constants.getImage(path: path, posterView: collectionCellImg)
            }
        }
    }
    
}
