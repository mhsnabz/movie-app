//
//  LandingCell.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit

class LandingCell: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(landindModel: LandingModel) {
        imgView.image = UIImage(named: landindModel.imageName) ?? UIImage()
    }
}
