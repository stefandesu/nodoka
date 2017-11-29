//
//  SettingsGongTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsGongTableViewController: UITableViewController {
    
    var currentGong: Int?
    var segueIdentifier: String?
    var delegate: SettingsTableViewController?
    let gongs = [
        0: "None",
        1: "1"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table background color
        tableView.backgroundColor = UIColor(red:0.13, green:0.14, blue:0.15, alpha:1.0)
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Set cell theme
        cell.backgroundColor = UIColor(red:0.20, green:0.21, blue:0.22, alpha:1.0)
        if cell.selectionStyle != .none {
            cell.selectionStyle = UITableViewCellSelectionStyle.gray
        }
        cell.tintColor = UIColor(red:0.93, green:0.46, blue:0.08, alpha:1.0)
        
        // Set theme of all cell labels
        let labels = ThemeHelper.findAllLabels(view: tableView)
        for label in labels {
            label.textColor = UIColor(red:0.79, green:0.79, blue:0.80, alpha:1.0)
        }
    }

}
