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
    
    override var owlImageVariant: ImageVariant { return .open }
    
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
        preparationTimeLabel.text = "\(preparationTimeString)"
        durationTimeLabel.text = "\(meditationTimeString)"
        
        // Set button labels
        settingsButton.setAttributedTitle(FontHelper.generate(icon: String.fontAwesomeIcon(name: .cog), withText: " Settings", ofSize: 17, andTextColor: Theme.currentTheme.accent), for: .normal)
        historyButton.setAttributedTitle(FontHelper.generate(icon: String.fontAwesomeIcon(name: .history), withText: " History", ofSize: 17, andTextColor: Theme.currentTheme.accent), for: .normal)
        changeDurationButton.setAttributedTitle(FontHelper.generate(icon: String.fontAwesomeIcon(name: .pencilSquare), withText: "", ofSize: 30, andTextColor: Theme.currentTheme.accent), for: .normal)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Put tab gesture recognizer on owl
        owlImage?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(start))
        tapGesture.numberOfTapsRequired = 1
        owlImage?.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Navigation
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindFromEndscreen(segue: UIStoryboardSegue) {
        
    }
    
    @objc func start() {
        if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PropertyKeys.meditationStoryboard) as? MeditationViewController {
            // Prepare destination view controller
            let meditationMinutes = userDefaults.integer(forKey: DefaultsKeys.duration)
            let preparationSeconds = userDefaults.integer(forKey: DefaultsKeys.preparation)
            destination.remainingTime = Double(meditationMinutes*60)
            destination.isOpenEnd = meditationMinutes == 0 ? true : false
            destination.preparationTime = Double(preparationSeconds)
            // Prepare transition animation
            let transition = CATransition.init()
            transition.duration = 0.5
            transition.type = kCATransitionFade
            // Push view controller
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(destination, animated: false)
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        start()
    }
    
}

