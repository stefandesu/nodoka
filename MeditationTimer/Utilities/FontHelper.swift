//
//  FontHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 06.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation
import UIKit

struct FontHelper {
    static func generate(icon: String, withText: String, ofSize: CGFloat, andTextColor: UIColor) -> NSAttributedString {
        let icon = NSMutableAttributedString(string: icon, attributes: [.font: UIFont.fontAwesome(ofSize: ofSize), .foregroundColor: andTextColor])
        let text = NSAttributedString(string: withText, attributes: [.font: UIFont.systemFont(ofSize: ofSize), .foregroundColor: andTextColor])
        icon.append(text)
        return icon
    }
}
