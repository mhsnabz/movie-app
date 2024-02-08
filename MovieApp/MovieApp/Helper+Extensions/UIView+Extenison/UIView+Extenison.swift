//
//  UIView+Extenison.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//
import UIKit
import Foundation
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.cornerRadius = newValue
               layer.masksToBounds = newValue > 0
           }
       }
       
       @IBInspectable var borderColor: UIColor? {
           get {
               if let color = layer.borderColor {
                   return UIColor(cgColor: color)
               }
               return nil
           }
           set {
               layer.borderColor = newValue?.cgColor
           }
       }
       
       @IBInspectable var borderWidth: CGFloat {
           get {
               return layer.borderWidth
           }
           set {
               layer.borderWidth = newValue
           }
       }
}
