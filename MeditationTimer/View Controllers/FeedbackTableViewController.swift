//
//  FeedbackTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 03.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class FeedbackTableViewController: ThemedTableViewController, TelegramHelperDelegate, UITextViewDelegate {
    
    struct LocalKeys {
        static let descriptionSection = 1
        static let submitSection = 3
    }
    
    let userDefaults = UserDefaults.standard
    
    func telegramResponse(success: Bool) {
        DispatchQueue.main.async {
            // Refresh table
            self.tableView.reloadData()
            // Reset user interaction
            self.tableView.isUserInteractionEnabled = true
            // Reset fields to default
            if success {
                self.fillFormFromDefaults()
            }
        }
    }
    
    func closeKeyboards() {
        contactTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    @IBAction func textFieldReturnPressed(_ sender: UITextField) {
        closeKeyboards()
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectedFeedbackType: UISegmentedControl!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(userDefaults.integer(forKey: DefaultsKeys.feedbackStatus))
        
        // Prepare keyboard stuff
        tableView.keyboardDismissMode = .interactive
        if let tableView = tableView as? FeedbackTableView {
            tableView.viewController = self
        }
        // Keyboard theme
        descriptionTextView.keyboardAppearance = Theme.currentTheme.keyboard
        contactTextField.keyboardAppearance = Theme.currentTheme.keyboard
        
        // Prepare if there's unsent feedback
        if userDefaults.integer(forKey: DefaultsKeys.feedbackStatus) != FeedbackStatus.notSubmitted.rawValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: LocalKeys.submitSection), at: .bottom, animated: true)
            }
        }
        fillFormFromDefaults()
        
        if userDefaults.integer(forKey: DefaultsKeys.feedbackStatus) == FeedbackStatus.submitting.rawValue {
            // Stop all interaction with table view
            tableView.isUserInteractionEnabled = false
        }
        
        // Prepare delegate for text view
        descriptionTextView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FeedbackHelper.shared.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FeedbackHelper.shared.delegate = nil
    }
    
    func fillFormFromDefaults() {
        selectedFeedbackType.selectedSegmentIndex = userDefaults.integer(forKey: DefaultsKeys.feedbackType)
        contactTextField.text = userDefaults.string(forKey: DefaultsKeys.feedbackAuthor)
        descriptionTextView.text = userDefaults.string(forKey: DefaultsKeys.feedbackDescription)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == LocalKeys.descriptionSection {
            // Text field
            return 128.0
        } else {
            return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == LocalKeys.submitSection {
            let currentSubmissionStatus = userDefaults.integer(forKey: DefaultsKeys.feedbackStatus)
            switch currentSubmissionStatus {
            case FeedbackStatus.notSubmitted.rawValue:
                return ""
            case FeedbackStatus.submitting.rawValue:
                return "Submitting..."
            case FeedbackStatus.submitFailed.rawValue:
                return "Submission failed. The data is saved locally, please try again later."
            case FeedbackStatus.submitSuccessful.rawValue:
                // Set status back to not submitted. Delay is a workaround for the table view refreshing too often
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                    self.userDefaults.set(FeedbackStatus.notSubmitted.rawValue, forKey: DefaultsKeys.feedbackStatus)
                })
                return "Submission complete! Thank you very much. :)"
            default:
                return nil
            }
        }
        return nil
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if descriptionTextView.text ?? "" == "" {
            let alertController = UIAlertController(title: "No Message", message: "Please provide some text about your feedback.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // Stop all interaction with table view
            tableView.isUserInteractionEnabled = false
            
            // Send feedback in background
            FeedbackHelper.shared.send()
            
            // Refresh table view
            tableView.reloadData()
        }
    }
    
    @IBAction func contactEditingChanged(_ sender: UITextField) {
        userDefaults.set(sender.text ?? "", forKey: DefaultsKeys.feedbackAuthor)
    }
    
    @IBAction func logSwitchChanged(_ sender: UISwitch) {
        closeKeyboards()
        userDefaults.set(sender.isOn, forKey: DefaultsKeys.feedbackLog)
    }
    
    @IBAction func typeSegmentChanged(_ sender: UISegmentedControl) {
        userDefaults.set(sender.selectedSegmentIndex, forKey: DefaultsKeys.feedbackType)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        userDefaults.set(textView.text ?? "", forKey: DefaultsKeys.feedbackDescription)
    }
    
}
