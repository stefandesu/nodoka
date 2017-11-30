//
//  SettingsTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsTableViewController: ThemedTableViewController {
    
    let userDefaults = UserDefaults.standard
    
    var startGong: Int = 0
    var endGong: Int = 0
    @IBOutlet weak var startGongLabel: UILabel!
    @IBOutlet weak var endGongLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load current settings from defaults
        startGong = userDefaults.integer(forKey: DefaultsKeys.startGong)
        endGong = userDefaults.integer(forKey: DefaultsKeys.endGong)
        
        
        updateLabels()
    }
    
    func updateLabels() {
        // Gong labels
        if startGong == 0 {
            startGongLabel.text = "None"
        } else {
            startGongLabel.text = "\(startGong)"
        }
        if endGong == 0 {
            endGongLabel.text = "None"
        } else {
            endGongLabel.text = "\(endGong)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.settingsGongStartSegue || identifier == PropertyKeys.settingsGongEndSegue {
            if let destination = segue.destination as? SettingsGongTableViewController {
                if identifier == PropertyKeys.settingsGongStartSegue {
                    destination.currentGong = startGong
                } else {
                    destination.currentGong = endGong
                }
                destination.delegate = self
                destination.segueIdentifier = identifier
            }
        }
    }
    
    func setGong(_ gong: Int, for identifier: String) {
        if identifier == PropertyKeys.settingsGongStartSegue {
            startGong = gong
            userDefaults.set(gong, forKey: DefaultsKeys.startGong)
        } else {
            endGong = gong
            userDefaults.set(gong, forKey: DefaultsKeys.endGong)
        }
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
