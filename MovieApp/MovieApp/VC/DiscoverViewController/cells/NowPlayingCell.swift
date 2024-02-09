//
//  NowPlayingCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit

class NowPlayingCell: UICollectionViewCell {
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var infoLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(movieListModel: Result) {
        if let title = movieListModel.originalTitle {
            titleLbl.text = title
        }

        if let avarageVote = movieListModel.voteAverage, let id = movieListModel.genreIDS, let date = movieListModel.releaseDate {
            var genre = ""
            id.forEach { id in
                genre = genre + "," + (GenreTitle(rawValue: id)?.name ?? "")
            }
            let index = genre.index(genre.startIndex, offsetBy: 0)
            genre.remove(at: index)
            infoLbl.getBullet(genre: genre, date: date, vote: avarageVote.rounded(toDecimalPlaces: 1))
        }

        if let image = movieListModel.backdropPath {
            coverImage.loadImage(url: image)
        }
    }
}
