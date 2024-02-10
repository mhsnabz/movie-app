//
//  DetailImageCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit

class DetailImageCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(data : DetailHeaderModel){
        imgView.loadImage(url: data.sourcePath ?? "")
    }
}
