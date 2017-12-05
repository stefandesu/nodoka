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
                statusText = "Apple Health integration authorized, but not enabled."
            } else {
                statusText = "Apple Health integration authorized and enabled."
            }
        case .sharingDenied:
            statusText = "Apple Health integration denied. Please go to Settings - Privacy - Health and allow this app to write mindfulness data."
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
            self.checkHealthKitAndRefresh()
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
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var healthSwitch: UISwitch!
    
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
        
        checkHealthKitAndRefresh()
    }
    
    func checkHealthKitAndRefresh() {
        if !isCurrentlyAuthorizingHealthKit {
            healthKitEnabled = userDefaults.bool(forKey: DefaultsKeys.healthKitEnabled)
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
            return nil
            // return "Recorded \(MeditationSession.index.count) meditation sessions."
        }
        return nil
    }
    
    func updateLabels() {
        // Theme label
        themeLabel.text = theme
        // Health Kit
        healthSwitch.isOn = healthKitEnabled
    }
    
    @IBAction func healthSwitchChanged(_ sender: Any) {
        if healthSwitch.isOn {
            setHealth(enabled: true, status: nil)
            isCurrentlyAuthorizingHealthKit = true
            HealthKitHelper.healthQueue.async {
                _ = HealthKitHelper.shared.authorizeHealthKit(delegate: self)
            }
        } else {
            setHealth(enabled: false, status: nil)
            checkHealthKitAndRefresh()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.settingsGongStartSegue {
            if let destination = segue.destination as? SettingsGongTableViewController {
                destination.currentStartGong = startGong
                destination.currentEndGong = endGong
                destination.delegate = self
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
    func setHealth(enabled: Bool, status: String?) {
        healthKitEnabled = enabled
        healthKitStatus = status ?? healthKitStatus
        userDefaults.set(enabled, forKey: DefaultsKeys.healthKitEnabled)
        updateLabels()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
