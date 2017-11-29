//
//  ThemeHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation
import UIKit

class ThemeHelper {
    static func findAllLabels(view: UIView, currentDepth: Int = 0, maxDepth: Int = 3) -> [UILabel] {
        guard currentDepth <= maxDepth else { return [UILabel]() }
        
        // Determine all UILabels on current layer
        var labels = view.subviews.flatMap { $0 as? UILabel }
        // Add all UILabels on next layer
        for subview in view.subviews {
            labels += findAllLabels(view: subview, currentDepth: currentDepth + 1, maxDepth: maxDepth)
        }
        return labels
    }
}
