//
//  ThemedUISwitch.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class ThemedUISwitch: UISwitch {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTheme()
    }
    
    func setUpTheme() {
        onTintColor = UIColor(red:0.93, green:0.46, blue:0.08, alpha:1.0)
    }
    
}
