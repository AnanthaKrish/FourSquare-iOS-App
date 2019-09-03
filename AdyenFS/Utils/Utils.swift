//
//  Utils.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
import UIKit

// Utils class for UI elements
class Utils {
    
    
    /**
     Get a custom UIView with color
     - parameter color: color for the view
     */
    class func getView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        return view
    }
    
    /**
     Get custom UILabel
     */
    class func getBaseLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = ""
        return titleLabel
    }
    
    /**
     Get custom UIButton
     */
    class func getBaseButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
