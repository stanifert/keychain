//
//  Extensions.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/30/20.
//

import UIKit

extension UIScrollView {
    
    func scrollToTop() {
        self.perform(NSSelectorFromString("_scrollToTopIfPossible:"), with: true)
    }
}
