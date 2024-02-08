//
//  HeaderLabel.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import Foundation
import UIKit

class HeaderLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    func setupLabel() {
        // Set your custom font here
        let customFont = UIFont(name: "Nunito-SemiBold", size: 17.0)
        
        // Set the label's font to the custom font
        self.font = customFont
    }
}
