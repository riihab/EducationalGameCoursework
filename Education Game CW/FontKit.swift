//
//  FontKit.swift
//  Education Game CW
//
//  Created by Rihab Mehboob on 11/12/2023.
//

import Foundation
import UIKit

// sets a font with size and font weight
class FontKit {
    
    static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let font: UIFont
        
        if #available(iOS 13.0, *) {
            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                font = UIFont(descriptor: descriptor, size: fontSize)
            } else {
                font = systemFont
            }
        } else {
            font = systemFont
        }
        
        return font
    }
}
