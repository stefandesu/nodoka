//
//  ThemedTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class ThemedTableViewController: UITableViewController {
    
    @IBOutlet var themedLabels: [UILabel] = []
    @IBOutlet var themedButtons: [UIButton] = []
    @IBOutlet var themedSwitches: [UISwitch] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTheme()
    }
    
    func setUpTheme() {
        // Set table view theme
        // Table background color
        tableView.backgroundColor = Theme.currentTheme.background
        // Navigation bar background (bar tint) color
        navigationController?.navigationBar.barTintColor = Theme.currentTheme.nagivationBar
        // Navigation bar title text color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Theme.currentTheme.text]
        // Navigation bar button (tint) color
        navigationController?.navigationBar.tintColor = Theme.currentTheme.accent
        // Refresh table
        tableView.reloadData()
        
        // Set up UI elements
        for label in themedLabels {
            label.textColor = Theme.currentTheme.text
        }
        for button in themedButtons {
            button.setTitleColor(Theme.currentTheme.accent, for: .normal)
        }
        for swiitch in themedSwitches {
            swiitch.onTintColor = Theme.currentTheme.accent
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Set cell theme
        cell.backgroundColor = Theme.currentTheme.cell
        cell.tintColor = Theme.currentTheme.accent
        
        let customSelectedView = UIView()
        customSelectedView.backgroundColor = Theme.currentTheme.cellSelected
        cell.selectedBackgroundView = customSelectedView
        
        // Set theme of all cell labels
        let labels = ThemeHelper.findAllLabels(view: cell)
        for label in labels {
            label.textColor = Theme.currentTheme.text
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
