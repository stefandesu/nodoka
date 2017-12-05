//
//  ViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 27.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit
import FontAwesome

class StartViewController: ThemedViewController {
    
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var preparationTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var changeDurationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var icon = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .cog), attributes: [.font: UIFont.fontAwesome(ofSize: 17), .foregroundColor: Theme.currentTheme.accent])
        var text = NSAttributedString(string: " Settings", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: Theme.currentTheme.accent])
        icon.append(text)
        settingsButton.setAttributedTitle(icon, for: .normal)
        
        icon = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .history), attributes: [.font: UIFont.fontAwesome(ofSize: 17), .foregroundColor: Theme.currentTheme.accent])
        text = NSAttributedString(string: " History", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: Theme.currentTheme.accent])
        icon.append(text)
        historyButton.setAttributedTitle(icon, for: .normal)
        
        icon = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .pencilSquare), attributes: [.font: UIFont.fontAwesome(ofSize: 30), .foregroundColor: Theme.currentTheme.accent])
        changeDurationButton.setAttributedTitle(icon, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh duration label
        let meditationTime = userDefaults.integer(forKey: DefaultsKeys.duration)
        let preparationTime = userDefaults.integer(forKey: DefaultsKeys.preparation)
        let meditationTimeString = meditationTime == 0 ? "Open End" : "\(meditationTime) Minute" + (meditationTime == 1 ? "" : "s")
        let preparationTimeString = preparationTime == 0 ? "No Preparation" : "\(preparationTime) Second" + (preparationTime == 1 ? "" : "s")
        preparationTimeLabel.text = "\(preparationTimeString)"
        durationTimeLabel.text = "\(meditationTimeString)"
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Navigation
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindFromEndscreen(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.startMeditationSegue, let destination = segue.destination as? MeditationViewController {
            let meditationMinutes = userDefaults.integer(forKey: DefaultsKeys.duration)
            let preparationSeconds = userDefaults.integer(forKey: DefaultsKeys.preparation)
            destination.remainingTime = Double(meditationMinutes*60)
            destination.isOpenEnd = meditationMinutes == 0 ? true : false
            destination.preparationTime = Double(preparationSeconds)
        }
    }
}

