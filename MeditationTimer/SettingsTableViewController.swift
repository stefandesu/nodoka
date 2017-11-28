//
//  SettingsTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 28.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

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
        if cell.selectionStyle != .none {
            cell.selectionStyle = UITableViewCellSelectionStyle.gray
        }
        
        // Set theme of all cell labels
        let labels = findAllLabels(view: tableView)
        for label in labels {
            label.textColor = UIColor(red:0.79, green:0.79, blue:0.80, alpha:1.0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func findAllLabels(view: UIView, currentDepth: Int = 0, maxDepth: Int = 3) -> [UILabel] {
        guard currentDepth <= maxDepth else { return [UILabel]() }
        
        // Determine all UILabels on current layer
        var labels = view.subviews.flatMap { $0 as? UILabel }
        // Add all UILabels on next layer
        for subview in view.subviews {
            labels += findAllLabels(view: subview, currentDepth: currentDepth + 1, maxDepth: maxDepth)
        }
        return labels
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
