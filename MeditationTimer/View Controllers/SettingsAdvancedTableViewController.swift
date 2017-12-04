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
        // Recognize tap for secret debug menu
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        tap.numberOfTapsRequired = 4
        tableView.addGestureRecognizer(tap)
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
    
    @IBAction func resetIntroScreenTapped(_ sender: Any) {
        userDefaults.set(false, forKey: DefaultsKeys.hasLaunchedApp)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if userDefaults.bool(forKey: DefaultsKeys.debugMenuEnabled) {
            return 2
        } else {
            return 1
        }
    }
    
    @objc func tableTapped(tap:UITapGestureRecognizer) {
        let location = tap.location(in: self.tableView)
        let path = self.tableView.indexPathForRow(at: location)
        if let indexPathForRow = path {
            tableView(self.tableView, didSelectRowAt: indexPathForRow)
        } else {
            // Handle tap on empty space below existing rows
            let newValue = !userDefaults.bool(forKey: DefaultsKeys.debugMenuEnabled)
            userDefaults.set(newValue, forKey: DefaultsKeys.debugMenuEnabled)
            tableView.reloadData()
        }
    }
    
}

