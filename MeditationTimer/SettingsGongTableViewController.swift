//
//  SettingsGongTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsGongTableViewController: ThemedTableViewController {
    
    var currentGong: Int?
    var segueIdentifier: String?
    var delegate: SettingsTableViewController?
    let gongs = [
        0: "None",
        1: "1"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return gongs.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.settingsGongCellIdentifier, for: indexPath)

        cell.textLabel?.text = gongs[indexPath.row]
        if indexPath.row == currentGong! {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.setGong(indexPath.row, for: segueIdentifier!)
        navigationController?.popViewController(animated: true)
    }
    
}
