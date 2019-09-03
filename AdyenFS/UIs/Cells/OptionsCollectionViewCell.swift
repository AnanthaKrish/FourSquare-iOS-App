//
//  OptionsCollectionViewCell.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 02/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import UIKit

// Filter options collactionview cell
class OptionsCollectionViewCell: UICollectionViewCell {
    
    
    lazy var optinsLabel: UILabel = {
        let titleLabel = Utils.getBaseLabel()
        titleLabel.font = Theme.labelFontH4
        titleLabel.textColor = .red
        
        return titleLabel
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Set up the UI
    fileprivate func setUpView() {
        
        selectedBackgroundView = Utils.getView(color: Theme.cellBgViewColor)
        backgroundView = Utils.getView(color: Theme.cellViewColor)
        layer.cornerRadius = 8.0
        
        addSubview(optinsLabel)
        optinsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        optinsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        optinsLabel.text = nil
    }
}
