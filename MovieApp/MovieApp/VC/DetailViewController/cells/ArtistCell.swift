//
//  ArtistCell.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var profile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(cast: Cast) {
        profile.loadImage(url: cast.profilePath ?? "")
        nameLbl.text = cast.originalName ?? ""
    }
}
