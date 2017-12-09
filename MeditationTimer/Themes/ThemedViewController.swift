//
//  ThemedViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class ThemedViewController: UIViewController {
    
    @IBOutlet var themedLabels: [UILabel] = []
    @IBOutlet var themedButtons: [UIButton] = []
    @IBOutlet var themedSwitches: [UISwitch] = []
    
    @IBOutlet weak var owlImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setUpTheme() {
        // Set table view theme
        
        // Set up logo image
        owlImage.image = Theme.currentTheme.logo
        
        // Table background color
        view.backgroundColor = Theme.currentTheme.background
        
        // Set up UI elements
        for label in themedLabels {
            label.textColor = Theme.currentTheme.text
        }
        for button in themedButtons {
            button.setTitleColor(Theme.currentTheme.accent, for: .normal)
        }
        for swiitch in themedSwitches {
            swiitch.onTintColor = Theme.currentTheme.accent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTheme()
    }
}
