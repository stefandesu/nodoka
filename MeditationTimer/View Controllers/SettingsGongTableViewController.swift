//
//  SettingsGongTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsGongTableViewController: ThemedTableViewController {
    
    var currentStartGong: Int?
    var currentEndGong: Int?
    var delegate: SettingsTableViewController?
    let gongs = [
        0: "None",
        1: "Gong 1"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 1 {
            return gongs.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.settingsGongCellIdentifier, for: indexPath)

        cell.textLabel?.text = gongs[indexPath.row]
        if (indexPath.section == 0 && indexPath.row == currentStartGong!) || (indexPath.section == 1 && indexPath.row == currentEndGong!) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
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
        } else {
            return nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioHelper.shared.stop()
    }
    
}
