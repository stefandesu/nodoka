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
    
    @IBAction func debugDeleteSavedSessions(_ sender: Any) {
        let result = MeditationSession.deleteAllSessions()
        let message = result ? "Sessions deleted." : "An error occured."
        let alertController = UIAlertController(title: "Deleting Sessions", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: false, completion: nil)
    }
    
}
