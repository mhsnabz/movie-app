//
//  NowPlayingCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit

class NowPlayingCell: UICollectionViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupUI(movieListModel : Result){
        if let title = movieListModel.originalTitle{
            self.titleLbl.text = title
        }
        
        if let avarageVote = movieListModel.voteAverage , let id = movieListModel.genreIDS , let date = movieListModel.releaseDate{
            var genre : String = ""
            id.forEach { id in
                genre = genre + "," + (GenreTitle(rawValue: id)?.name ?? "")
            }
            let index = genre.index(genre.startIndex, offsetBy: 0) 
            genre.remove(at: index)
            infoLbl.getBullet(genre: genre, date: date,vote: avarageVote.rounded(toDecimalPlaces: 1))
        }
        
        if let image = movieListModel.backdropPath{
            coverImage.loadImage(url: image)
        }
    }
}
