//
//  ThemedTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 29.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class ThemedTableViewController: UITableViewController {

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
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Set cell theme
        cell.backgroundColor = UIColor(red:0.20, green:0.21, blue:0.22, alpha:1.0)
        cell.tintColor = UIColor(red:0.93, green:0.46, blue:0.08, alpha:1.0)
        
        let customSelectedView = UIView()
        customSelectedView.backgroundColor = UIColor(red:0.30, green:0.31, blue:0.52, alpha:1.0)
        cell.selectedBackgroundView = customSelectedView
        
        // Set theme of all cell labels
        let labels = ThemeHelper.findAllLabels(view: tableView)
        for label in labels {
            label.textColor = UIColor(red:0.79, green:0.79, blue:0.80, alpha:1.0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
