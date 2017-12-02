//
//  SettingsDurationTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 02.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class SettingsDurationTableViewController: ThemedTableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var meditationTimePicker: UIPickerView!
    @IBOutlet weak var preparationTimePicker: UIPickerView!
    
    var meditationTimeList: [String] {
        var list = ["Open End"]
        for minutes in 1...45 {
            list.append("\(minutes) \(minutes == 1 ? "minute" : "minutes")")
        }
        return list
    }
    
    var preparationTimeList: [String] {
        var list = ["No Preparation"]
        for seconds in 1...60 {
            list.append("\(seconds) \(seconds == 1 ? "second" : "seconds")")
        }
        return list
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Durations"
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        meditationTimePicker.delegate = self
        meditationTimePicker.dataSource = self
        preparationTimePicker.delegate = self
        preparationTimePicker.dataSource = self
        
        meditationTimePicker.selectRow(userDefaults.integer(forKey: DefaultsKeys.duration), inComponent: 0, animated: false)
        preparationTimePicker.selectRow(userDefaults.integer(forKey: DefaultsKeys.preparation), inComponent: 0, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        meditationTimePicker.reloadAllComponents()
        preparationTimePicker.reloadAllComponents()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == PropertyKeys.preparationPickerTag {
            return preparationTimePicker.bounds.height / 1.5
        } else if indexPath.section == PropertyKeys.meditationPickerTag {
            return meditationTimePicker.bounds.height
        } else {
            return 44.0
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == PropertyKeys.preparationPickerTag {
            // Preparation time picker
            return preparationTimeList.count
        } else {
            // Meditation time picker
            return meditationTimeList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == PropertyKeys.preparationPickerTag {
            // Preparation time picker
            return NSAttributedString(string: preparationTimeList[row], attributes: [NSAttributedStringKey.foregroundColor: Theme.currentTheme.text])
        } else {
            // Meditation time picker
            return NSAttributedString(string: meditationTimeList[row], attributes: [NSAttributedStringKey.foregroundColor: Theme.currentTheme.text])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == PropertyKeys.preparationPickerTag {
            userDefaults.set(row, forKey: DefaultsKeys.preparation)
        } else {
            userDefaults.set(row, forKey: DefaultsKeys.duration)
        }
    }
}
