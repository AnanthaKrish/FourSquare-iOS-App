//
//  HomeCollectionViewCell.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import UIKit

// Home collectionview custom cell
class HomeCollectionViewCell: UICollectionViewCell {

    // venue model for the data handle
    var venueCellViewModel: VenueCellViewModel? {
        didSet {
            self.setUpCell()
        }
    }
    
    private lazy var venueNameLabel: UILabel = {
        let titleLabel = Utils.getBaseLabel()
        titleLabel.font = Theme.labelFontH1
        titleLabel.textColor = Theme.labelFontH1Color
        return titleLabel
    }()
    
    private lazy var venueAddressLabel: UILabel = {
        let titleLabel = Utils.getBaseLabel()
        titleLabel.font = Theme.labelFontH2
        titleLabel.textColor = Theme.labelFontH2Color
        return titleLabel
    }()
    
    private lazy var venueDistanceLabel: UILabel = {
        let titleLabel = Utils.getBaseLabel()
        titleLabel.font = Theme.labelFontH2
        titleLabel.textColor = Theme.labelFontH3Color
        return titleLabel
    }()
    
    var venueImageView:UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.backgroundColor = .white
        imgV.image = #imageLiteral(resourceName: "NoImageFound")
        imgV.layer.cornerRadius = 8.0
        imgV.layer.masksToBounds = true
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5.0
        return stackView
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
        
        backgroundView = Utils.getView(color: Theme.cellViewColor)
        selectedBackgroundView = Utils.getView(color: Theme.cellBgViewColor)
        contentView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        contentView.addSubview(venueImageView)
        ///self.addSubview(venueImageView)
        
        venueImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        venueImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        venueImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        venueImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        
        stackView.addArrangedSubview(venueNameLabel)
        stackView.addArrangedSubview(venueAddressLabel)
        stackView.addArrangedSubview(venueDistanceLabel)
        contentView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.venueImageView.trailingAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.8).isActive = true
    }
    
    // set Up cell 
    public func setUpCell() {
        if let venueCellViewModel = self.venueCellViewModel, let rec = venueCellViewModel.recommendations {
            venueNameLabel.text = rec.name
            venueAddressLabel.text = rec.address
            venueAddressLabel.isHidden = venueAddressLabel.text == "" ? true : false
            venueDistanceLabel.text = rec.distance
            venueDistanceLabel.isHidden = venueDistanceLabel.text == "" ? true : false

            if rec.imageUrl == nil {
                self.venueCellViewModel?.loadImageUrl()
            }
        }
    }
    
    override func prepareForReuse() {
        venueCellViewModel = nil
        venueNameLabel.text = ""
        venueAddressLabel.text = ""
        venueDistanceLabel.text = ""
    }
    

}
