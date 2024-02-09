//
//  UILabel+Extension.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation
import UIKit
extension UILabel{
    func getBullet(genre : String , date : String , vote : String) {
        let attributedString = NSMutableAttributedString()
        
        let bulletPoint: String = "\u{2022}"
        let bulletPointAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Nunito-Regular", size: 12) ?? UIFont.systemFont(ofSize: 16) , .foregroundColor : UIColor.white]
        
        let listItem = NSAttributedString(string: genre,attributes: [.font : UIFont(name: "Nunito-Regular", size: 12) ?? UIFont.systemFont(ofSize: 16) , .foregroundColor : UIColor.white ])
        attributedString.append(listItem)
        
        let bulletPointString = NSMutableAttributedString(string: "\(bulletPoint) ", attributes: bulletPointAttributes)
        attributedString.append(bulletPointString)
        
        let listItem3 = NSAttributedString(string: vote,attributes: [.font : UIFont(name: "Nunito-Regular", size: 12) ?? UIFont.systemFont(ofSize: 16) , .foregroundColor : UIColor.white ])
        attributedString.append(listItem3)
        
        attributedString.append(bulletPointString)
        
        let listItem2 =  NSAttributedString(string: "(\(date))",attributes: [.font : UIFont(name: "Nunito-Regular", size: 12) ?? UIFont.systemFont(ofSize: 16) , .foregroundColor : UIColor.white ])
        attributedString.append(listItem2)
        
        self.attributedText = attributedString
    }
}
