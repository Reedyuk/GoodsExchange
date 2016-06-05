//
//  Constants.swift
//  GoodsExchange
//
//  Created by Andrew Reed on 03/06/2016.
//  Copyright © 2016 Andrew Reed. All rights reserved.
//

import UIKit
import Foundation

/// The struct used to contain simple constants.
struct Constants {

    /// All theme related operations
    struct Theme {
        /// Method used to update the theme throughout the app
        static func updateTheme() {
            let sharedApplication = UIApplication.sharedApplication()
            sharedApplication.delegate?.window??.tintColor = Constants.Theme.defaultTintColour
            UINavigationBar.appearance().barStyle = Constants.Theme.defaultBarStyle
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Constants.Theme.defaultTintColour], forState:.Selected)
            UIBarButtonItem.appearance().tintColor = Constants.Theme.defaultTintColour
            UINavigationBar.appearance().tintColor = Constants.Theme.defaultTintColour
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Constants.Theme.defaultTabTextTint], forState:.Normal)
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3), NSForegroundColorAttributeName: Constants.Theme.defaultNavTextTint]
            UITabBar.appearance().barStyle = Constants.Theme.defaultBarStyle
            UIApplication.sharedApplication().statusBarStyle = Constants.Theme.defaultStatusBarStyle
        }
        
        static var defaultTintColour : UIColor {
            get {
                return UIColor(red: 232.0/255.0, green: 71.0/255.0, blue: 21.0/255.0, alpha: 1.0)
            }
        }
        
        static var defaultStatusBarStyle : UIStatusBarStyle {
            get {
                return .LightContent
            }
        }
        
        static var defaultBarStyle : UIBarStyle {
            get {
                return .Default
            }
        }
        
        static var defaultNavTextTint : UIColor {
            get {
                return UIColor.whiteColor()
            }
        }
        
        static var defaultTabTextTint : UIColor {
            get {
                return UIColor.whiteColor()
            }
        }
        
    }
    
    /// The api related constants
    struct Api {
        /// access key for json rates
        static let jsonRatesKey = "1e76545d738b1a74b86e048b34a6757c"
        /// The url for getting the jsonRates
        static let jsonRatesUrl = "http://apilayer.net/api"
    }


}
