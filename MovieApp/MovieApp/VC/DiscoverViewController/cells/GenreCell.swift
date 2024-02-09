//
//  GenreCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit

class GenreCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override var isSelected: Bool{
        didSet{
            titlelbl.textColor = isSelected ? .darkRed : .white
            backView.borderColor = isSelected ? .darkRed : .white
        }
    }
    
    func setupCell(genreTitle : GenreTitle){
        titlelbl.text = genreTitle.name
    }
}
