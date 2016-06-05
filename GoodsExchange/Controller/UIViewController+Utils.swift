//
//  UIViewController+Utils.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 04/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import UIKit

/// Handle methods that are commonly used between all view controllers.
extension UIViewController {
    
    /// setupBackButton: Method to show just an arrow on the nav bar.
    func setupBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }
    
    /// showErrorAlert: Simple method to present alert message
    /// - Parameter title: The title of the error message
    /// - Parameter message: The message of the alert
    /// - Parameter actionTitle: The title of the action button
    func showErrorAlert(title:String?, message:String?, actionTitle:String?) {
        if self.isViewLoaded() && self.view.window != nil {
            let localAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            localAlert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(localAlert, animated: true, completion: nil)
        }
    }
}