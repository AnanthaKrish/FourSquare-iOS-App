//
//  UIImageView+image.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /**
     Get image from the url
     - parameter fromURL: url of the image
     - parameter completionHandler: Completion handler
     */
    public func image(fromURL url:URL,completionHandler:@escaping ((_ succes:Bool?, _ error:Error?)->Void)) {
        
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            activityIndicator.startAnimating()
            if self.image == nil {
                self.addSubview(activityIndicator)
            }
            
            
            APIConnect.getImage(for: url) { (image, success, error) in
                
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    
                    if let error = error {
                        print("Error while fetching image")
                        completionHandler(false, error)
                        return
                    }
                    self.image = image
                }
                completionHandler(true, nil)
            }
            
        }}
}


extension UIImageView {
    
    /**
     Get image from the url
     - parameter fromURL: url of the image
     */
    
    func getImageFromUrl(url:URL) {
        self.image(fromURL: url , completionHandler: { (success, error) in
            
            guard error == nil else {
                self.image = #imageLiteral(resourceName: "NoImageFound")
                return
            }
            print("set image")
        })
    }
}
