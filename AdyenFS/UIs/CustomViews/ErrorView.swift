//
//  ErrorView.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 02/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import UIKit

// Error View
class ErrorView: UIView {
    
    // MARK: Variables
    
    // Reload action closure
    var reloadViewClosure: (()->())?

    // Error Label
    private lazy var errorLabel: UILabel = {
        let titleLabel = Utils.getBaseLabel()
        titleLabel.font = Theme.labelFontH4
        titleLabel.textColor = Theme.labelFontH1Color
        titleLabel.text = RELOAD_MESSAGE
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    // Reload button
    private lazy var reloadButton: UIButton = {
        let button = Utils.getBaseButton()
        button.titleLabel?.font = Theme.labelFontH2
        button.setTitleColor(Theme.navBarTitleColor, for: .normal)
        button.backgroundColor = Theme.buttonBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(RELOAD_BUTTON, for: .normal)
        button.addTarget(self, action: #selector(relaodAction), for: .touchUpInside)
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    // init method
    internal override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpView()
    }
    
    // Set Up the view elements
    func setUpView() {
        
        addSubview(errorLabel)
        addSubview(reloadButton)
        
        errorLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 80).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        errorLabel.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.6).isActive = true
        
        reloadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10).isActive = true
        reloadButton.centerXAnchor.constraint(equalTo: errorLabel.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Reload button click action
    @objc func relaodAction() {
        reloadViewClosure?()
    }
}
