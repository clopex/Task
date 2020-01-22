//
//  UIViewControllerExt.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
    
    func showAlertWith(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
    
    var activityIndicatorTag: Int { return 999999 }
    
    func startActivityIndicator(
        style: UIActivityIndicatorView.Style = .whiteLarge,
        location: CGPoint? = nil) {
        
        let loc = location ?? self.view.center
        
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(style: style)
            //Add the tag so we can find the view in order to remove it later
            
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.color = UIColor.darkGray
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
