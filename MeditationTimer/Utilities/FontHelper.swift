//
//  FontHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 06.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome

struct FontHelper {
    static func generate(icon: String, withText: String, ofSize: CGFloat, andTextColor: UIColor, style: FontAwesomeStyle) -> NSAttributedString {
        let icon = NSMutableAttributedString(string: icon, attributes: [.font: UIFont.fontAwesome(ofSize: ofSize, style: style), .foregroundColor: andTextColor])
        let text = NSAttributedString(string: withText, attributes: [.font: UIFont.systemFont(ofSize: ofSize), .foregroundColor: andTextColor])
        icon.append(text)
        return icon
    }
}
