//
//  ViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 27.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class StartViewController: ThemedViewController {
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh duration label
        let meditationTime = userDefaults.integer(forKey: DefaultsKeys.duration)
        let preparationTime = userDefaults.integer(forKey: DefaultsKeys.preparation)
        let meditationTimeString = meditationTime == 0 ? "Open End" : "\(meditationTime) Minute" + (meditationTime == 1 ? "" : "s")
        let preparationTimeString = preparationTime == 0 ? "No Preparation" : "\(preparationTime) Second" + (preparationTime == 1 ? "" : "s")
        durationLabel.text = "Preparation: \(preparationTimeString)\nMeditation: \(meditationTimeString)"
        
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
            let preparationSeconds = userDefaults.integer(forKey: DefaultsKeys.duration)
            destination.remainingTime = Double(meditationMinutes*60)
            destination.isOpenEnd = meditationMinutes == 0 ? true : false
            destination.preparationTime = Double(preparationSeconds)
        }
    }
}

