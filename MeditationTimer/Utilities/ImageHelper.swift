//
//  ImageHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 10.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation
import UIKit

enum ImageVariant: String {
    case open_yay = "open_yay"
    case open = "open"
    case half = "half"
    case closed = "closed"
}
enum ImageTheme: String {
    case dark = "dark"
    case light = "light"
}

class ImageHelper {
    static let imagePrefix = "owl_image_"
    
    static func getImage(variant: ImageVariant, theme: ImageTheme = Theme.currentTheme.imageTheme) -> UIImage? {
        return UIImage.init(named: imagePrefix + variant.rawValue + "_" + theme.rawValue)
    }
}
