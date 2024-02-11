//
//  UIView+Extenison.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//
import Foundation
import UIKit
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

    func animationCloseWindow(for view: UIView, completion: @escaping () -> Void) {
        transform = .identity
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { () in
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { (_: Bool) in
            view.isHidden = true
            completion()
        })
    }

    func animationOpenWindow(for view: UIView, completion: @escaping () -> Void) {
        transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { () in
            view.transform = .identity
        }, completion: { (_: Bool) in
            completion()
        })
    }
}
