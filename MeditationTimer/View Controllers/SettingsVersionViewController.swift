//
//  SettingsVersionViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 01.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsVersionViewController: ThemedViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set version label
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] ?? "?"
        versionLabel.text = "Version \(version) (\(build))"
        
        // Set up logo image
        logoImageView.image = Theme.currentTheme.logo
        
        // Set up text view theme
        aboutTextView.backgroundColor = UIColor.clear
        aboutTextView.textColor = Theme.currentTheme.text
        aboutTextView.linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: Theme.currentTheme.accent ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        aboutTextView.dataDetectorTypes = .link
    }

}
