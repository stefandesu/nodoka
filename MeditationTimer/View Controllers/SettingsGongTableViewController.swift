//
//  SettingsGongTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsGongTableViewController: ThemedTableViewController, SetSoundTableViewCellDelegate {
    func useSystemSoundSwitchChanged(to: Bool) {
        useSystemSound = to
        tableView.beginUpdates()
        UserDefaults.standard.set(to, forKey: DefaultsKeys.useSystemSound)
        tableView.endUpdates()
    }
    
    func defaultSoundVolumeChanged(to: Float) {
        UserDefaults.standard.set(to, forKey: DefaultsKeys.soundVolume)
        // Play gong as preview
        AudioHelper.shared.stop()
        let currentStartGongLocal = currentStartGong ?? 0
        let currentEndGongLocal = currentEndGong ?? 0
        let playSound = currentStartGongLocal != 0 ? currentStartGongLocal : ( currentEndGongLocal != 0 ? currentEndGongLocal : 1 )
        AudioHelper.shared.play(playSound)
    }
    
    
    var currentStartGong: Int?
    var currentEndGong: Int?
    var delegate: SettingsTableViewController?
    let gongs = [
        0: "None",
        1: "Gong 1"
    ]
    var useSystemSound = UserDefaults.standard.bool(forKey: DefaultsKeys.useSystemSound)

    override func viewDidLoad() {
        super.viewDidLoad()
        // set up 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 1 {
            return gongs.count
        } else if section == 2 {
            return useSystemSound ? 1 : 2
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section <= 1 {
            // Dynamic cells
            let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.settingsGongCellIdentifier, for: indexPath)
            cell.textLabel?.text = gongs[indexPath.row]
            if (indexPath.section == 0 && indexPath.row == currentStartGong!) || (indexPath.section == 1 && indexPath.row == currentEndGong!) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else if indexPath.section == 2 {
            // Static cells
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.setSound1TableViewCellIdentifier) as? SetSound1TableViewCell
                if cell == nil {
                    tableView.register(UINib(nibName: "SetSound1TableViewCell", bundle: nil), forCellReuseIdentifier: PropertyKeys.setSound1TableViewCellIdentifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.setSound1TableViewCellIdentifier) as? SetSound1TableViewCell
                }
                cell!.delegate = self
                cell!.useSystemSoundSwitch.isOn = useSystemSound
                return cell!
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.setSound2TableViewCellIdentifier) as? SetSound2TableViewCell
                if cell == nil {
                    tableView.register(UINib(nibName: "SetSound2TableViewCell", bundle: nil), forCellReuseIdentifier: PropertyKeys.setSound2TableViewCellIdentifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.setSound2TableViewCellIdentifier) as? SetSound2TableViewCell
                }
                cell!.delegate = self
                cell!.soundVolumeSlider.value = UserDefaults.standard.float(forKey: DefaultsKeys.soundVolume)
                return cell!
            }
        } else {
            return UITableViewCell()
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var playSound: Int
        if indexPath.section == 0 {
            // Start sound
            delegate?.setGong(indexPath.row, for: PropertyKeys.settingsGongStartSegue)
            currentStartGong = indexPath.row
            playSound = currentStartGong!
        } else if indexPath.section == 1 {
            // End sound
            delegate?.setGong(indexPath.row, for: PropertyKeys.settingsGongEndSegue)
            currentEndGong = indexPath.row
            playSound = currentEndGong!
        } else {
            return
        }
        // Play gong as preview
        AudioHelper.shared.stop()
        if playSound != 0 {
            AudioHelper.shared.play(playSound)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Start Sound"
        } else if section == 1 {
            return "End Sound"
        } else if section == 2 {
            // return "Use System Sound Volume"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return "Note: Due to system limitations, an exact volume level independent of the system volume can't be guaranteed. This is only an approximation."
        }
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioHelper.shared.stop()
    }
    
}
