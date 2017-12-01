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
    
    @IBAction func debugDeleteSavedSessions(_ sender: UIButton) {
        let debugQueue = DispatchQueue(label: "debugQueue", attributes: .concurrent)
        sender.setTitle("Deleting...", for: .normal)
        debugQueue.async {
            MeditationSession.deleteAllSessions()
            DispatchQueue.main.async {
                sender.setTitle("Deleting of sessions done.", for: .normal)
            }
        }
    }
    @IBAction func debugCreateLocalSessions(_ sender: UIButton) {
        let debugQueue = DispatchQueue(label: "debugQueue", attributes: .concurrent)
        sender.setTitle("Creating...", for: .normal)
        debugQueue.async {
            for _ in 1...100 {
                let session = MeditationSession(date: Date(), duration: 60)
                session.save()
            }
            DispatchQueue.main.async {
                sender.setTitle("Creating of sessions done.", for: .normal)
            }
        }
    }
    
}

