//
//  SettingsTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit
import HealthKit

class SettingsTableViewController: ThemedTableViewController, HealthKitHelperDelegate {
    
    func healthKitCheckComplete(authorizationStatus: HKAuthorizationStatus) {
        var statusText = ""
        var enabled = self.healthKitEnabled
        switch authorizationStatus {
        case .sharingAuthorized:
            if !enabled {
                statusText = "HealthKit sharing authorized, but not enabled."
            } else {
                statusText = "HealthKit sharing authorized."
            }
        case .sharingDenied:
            statusText = "Sharing Denied. Please blablabla"
            enabled = false
        case .notDetermined:
            statusText = "Enabling Apple Health integration will ask you for system permission."
            enabled = false
        }
        DispatchQueue.main.async {
            self.setHealth(enabled: enabled, status: statusText)
        }
    }
    
    func healthKitWriteComplete(status: Bool) {
        
    }
    
    func healthKitAuthorizeComplete(status: Bool) {
        DispatchQueue.main.async {
            self.isCurrentlyAuthorizingHealthKit = false
            if status {
                self.setHealth(enabled: true, status: "Authorization successful!")
            } else {
                self.setHealth(enabled: false, status: "Authorization failed. :(")
            }
        }
        // Retrospectively write unwritten sessions
        if status {
            for session in MeditationSession.getAllSessions() {
                if !session.savedToHealth {
                    HealthKitHelper.shared.writeMindfulnessData(delegate: nil, session: session)
                }
            }
        }
    }
    
    
    let userDefaults = UserDefaults.standard
    
    var startGong: Int = 0
    var endGong: Int = 0
    var theme: String = ""
    var healthKitEnabled = false
    var healthKitStatus = ""
    var isCurrentlyAuthorizingHealthKit = false
    @IBOutlet weak var startGongLabel: UILabel!
    @IBOutlet weak var endGongLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var healthSwitch: UISwitch!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
              name: .UIApplicationDidBecomeActive,
              object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
            name: .UIApplicationDidBecomeActive,
            object: nil)
        
        refreshView()
    }
    
    func refreshView() {
        // Load current settings from defaults
        startGong = userDefaults.integer(forKey: DefaultsKeys.startGong)
        endGong = userDefaults.integer(forKey: DefaultsKeys.endGong)
        theme = userDefaults.string(forKey: DefaultsKeys.theme)!
        
        if !isCurrentlyAuthorizingHealthKit {
            healthKitEnabled = userDefaults.bool(forKey: DefaultsKeys.healthKitEnabled)
            healthKitStatus = "Checking Apple Health status..."
            HealthKitHelper.healthQueue.async {
                _ = HealthKitHelper.shared.checkAuthorizationStatus(delegate: self)
            }
        }
        updateLabels()
    }
    
    @objc func applicationDidBecomeActive() {
        refreshView()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return healthKitStatus
        } else if section == 2 {
            return "Recorded \(MeditationSession.index.count) meditation sessions."
        }
        return nil
    }
    
    func updateLabels() {
        // Update Duration Label
        let meditationTime = userDefaults.integer(forKey: DefaultsKeys.duration)
        let preparationTime = userDefaults.integer(forKey: DefaultsKeys.preparation)
        let meditationTimeString = meditationTime == 0 ? "Open End" : "\(meditationTime) min."
        let preparationTimeString = "\(preparationTime) sec."
        durationLabel.text = "\(preparationTimeString) | \(meditationTimeString)"
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
        // Theme label
        themeLabel.text = theme
        // Health Kit
        healthSwitch.isOn = healthKitEnabled
    }
    
    @IBAction func healthSwitchChanged(_ sender: Any) {
        if healthSwitch.isOn {
            healthKitStatus = "Authorizing..."
            updateLabels()
            isCurrentlyAuthorizingHealthKit = true
            HealthKitHelper.healthQueue.async {
                _ = HealthKitHelper.shared.authorizeHealthKit(delegate: self)
            }
        } else {
            setHealth(enabled: false, status: "Apple Health disabled.")
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
        if identifier == PropertyKeys.settingsThemeSegue {
            if let destination = segue.destination as? SettingsThemeTableViewController {
                destination.delegate = self
                destination.currentThemeName = theme
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
    func setTheme(_ theme: String) {
        userDefaults.set(theme, forKey: DefaultsKeys.theme)
        updateLabels()
        UIApplication.shared.statusBarStyle = Theme.currentTheme.statusBar
    }
    func setHealth(enabled: Bool, status: String) {
        healthKitEnabled = enabled
        healthKitStatus = status
        userDefaults.set(enabled, forKey: DefaultsKeys.healthKitEnabled)
        updateLabels()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
