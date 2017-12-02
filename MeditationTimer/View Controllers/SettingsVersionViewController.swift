//
//  SettingsVersionViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 01.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsVersionViewController: ThemedViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set version label
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] ?? "?"
        versionLabel.text = "Version \(version) (\(build))"
    }

}
