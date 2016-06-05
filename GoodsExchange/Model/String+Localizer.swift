//
//  String+Localizer.swift
//
//
//  Created by Andrew Reed on 17/03/2016.
//  Copyright © 2016 . All rights reserved.
//

import Foundation

/// Extension of the String object in relation to localisation
extension String {
    ///localized: adjust the string to set the string in the comment
    /// - returns: The formatted localised string
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    ///uppercaseFirst: adjusts the first character to be upper case.
    /// - returns: The formatted string
    var uppercaseFirst: String {
        if isEmpty { return "" }
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).uppercaseString)
        return result
    }
}