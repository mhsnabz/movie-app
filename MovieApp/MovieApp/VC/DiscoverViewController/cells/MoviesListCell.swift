//
//  MoviesListCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit

class MoviesListCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var votedCount: UILabel!
    @IBOutlet weak var avarageRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(result : Result , section : Int){
        if section == 0{
            if let stringUrl = result.backdropPath {
                poster.loadImage(url: stringUrl)
            }
        }else{
            if let stringUrl = result.posterPath {
                poster.loadImage(url: stringUrl)
            }
        }
       
        if let avarageRate = result.voteAverage , let voteCount = result.voteCount{
            self.avarageRate.text = avarageRate.rounded()
            self.votedCount.text = voteCount.formatAbbreviated()
        }
        
        if let title = result.title{
            self.titleLbl.text = title
        }
    }
    
}
