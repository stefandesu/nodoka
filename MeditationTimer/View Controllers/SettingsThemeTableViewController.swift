//
//  SettingsGongTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsThemeTableViewController: ThemedTableViewController {
    
    var currentThemeName: String?
    var delegate: SettingsTableViewController?

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
            return Theme.availableThemes.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.settingsThemeCellIdentifier, for: indexPath)

        let themeName = Theme.availableThemes[indexPath.row]
        cell.textLabel?.text = themeName
        if themeName == currentThemeName! {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let themeName = Theme.availableThemes[indexPath.row]
        delegate?.setTheme(themeName)
        currentThemeName = themeName
        setUpTheme()
    }
    
}
