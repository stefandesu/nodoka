//
//  SettingsTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    
    var startGong: Int = 0
    var endGong: Int = 0
    @IBOutlet weak var startGongLabel: UILabel!
    @IBOutlet weak var endGongLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set table view theme
        // Table background color
        tableView.backgroundColor = UIColor(red:0.13, green:0.14, blue:0.15, alpha:1.0)
        // Navigation bar background (bar tint) color
        navigationController?.navigationBar.barTintColor = UIColor(red:0.06, green:0.07, blue:0.08, alpha:1.0)
        // Navigation bar title text color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.79, green:0.79, blue:0.80, alpha:1.0)]
        // Navigation bar button (tint) color
        navigationController?.navigationBar.tintColor = UIColor(red:0.93, green:0.46, blue:0.08, alpha:1.0)
        
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Set cell theme
        cell.backgroundColor = UIColor(red:0.20, green:0.21, blue:0.22, alpha:1.0)
        if cell.selectionStyle != .none {
            cell.selectionStyle = UITableViewCellSelectionStyle.gray
        }
        
        // Set theme of all cell labels
        let labels = ThemeHelper.findAllLabels(view: tableView)
        for label in labels {
            label.textColor = UIColor(red:0.79, green:0.79, blue:0.80, alpha:1.0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
