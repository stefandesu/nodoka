//
//  ViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 27.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var durationPicker: UIPickerView!
    
    var durationList: [String] {
        var list = ["Open End"]
        for minutes in 1...45 {
            list.append("\(minutes) \(minutes == 1 ? "minute" : "minutes")")
        }
        return list
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UIPickerView
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.selectRow(userDefaults.integer(forKey: DefaultsKeys.duration.rawValue), inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationList.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        // TODO: Switch to using themes
        return NSAttributedString(string: durationList[row], attributes: [NSAttributedStringKey.foregroundColor: UIColor(red:0.79, green:0.79, blue:0.80, alpha:1.0)])
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userDefaults.set(row, forKey: DefaultsKeys.duration.rawValue)
    }
    
    // MARK: - Navigation
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindFromEndscreen(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == PropertyKeys.startMeditationSegue, let destination = segue.destination as? MeditationViewController {
            let minutes = durationPicker.selectedRow(inComponent: 0)
            destination.remainingTime = Double(minutes) // TODO: * 60 for minutes (seconds for testing)
            destination.isOpenEnd = minutes == 0 ? true : false
        }
    }
}

