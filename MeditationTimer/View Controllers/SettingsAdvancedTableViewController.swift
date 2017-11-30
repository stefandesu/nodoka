//
//  SettingsAdvancedTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 30.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsAdvancedTableViewController: ThemedTableViewController {

    @IBOutlet weak var brightnessSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brightnessSwitch.isOn = userDefaults.bool(forKey: DefaultsKeys.changedBrightness)
    }

    @IBAction func brightnessSwitchChanged(_ sender: UISwitch) {
        userDefaults.set(brightnessSwitch.isOn, forKey: DefaultsKeys.changedBrightness)
    }
}
