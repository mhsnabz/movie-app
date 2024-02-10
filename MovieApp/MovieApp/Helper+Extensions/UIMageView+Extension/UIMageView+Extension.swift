//
//  UIMageView+Extension.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation
import SDWebImage
extension UIImageView {
    func loadImage(url: String) {
        let stringUrl = "http://image.tmdb.org/t/p/w500" + url
        if let newUrl = URL(string: stringUrl) {
            sd_imageIndicator = SDWebImageActivityIndicator.white
            sd_setImage(with: newUrl, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
