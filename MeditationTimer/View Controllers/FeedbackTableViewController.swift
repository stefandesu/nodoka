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
    
    enum SubmissionStatus {
        case notSubmitted, sending, submitSuccessful, submitFailed
    }
    var currentSubmissionStatus: SubmissionStatus = .notSubmitted
    
    func telegramResponse(success: Bool) {
        DispatchQueue.main.async {
            self.currentSubmissionStatus = success ? .submitSuccessful : .submitFailed
            self.tableView.reloadData()
            self.sendButton.isEnabled = true
            self.userDefaults.set(true, forKey: DefaultsKeys.feedbackNotSent)
            if success {
                self.resetFeedbackDefaults()
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
        
        // Prepare keyboard stuff
        tableView.keyboardDismissMode = .interactive
        if let tableView = tableView as? FeedbackTableView {
            tableView.viewController = self
        }
        // Keyboard theme
        descriptionTextView.keyboardAppearance = Theme.currentTheme.keyboard
        contactTextField.keyboardAppearance = Theme.currentTheme.keyboard
        
        // Prepare if there's unsent feedback
        if userDefaults.bool(forKey: DefaultsKeys.feedbackNotSent) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 4), at: .bottom, animated: true)
            }
        }
        fillFormFromDefaults()
        
        // Prepare delegate for text view
        descriptionTextView.delegate = self
    }
    
    func resetFeedbackDefaults() {
        userDefaults.set(false, forKey: DefaultsKeys.feedbackNotSent)
        userDefaults.set(0, forKey: DefaultsKeys.feedbackType)
        userDefaults.set(false, forKey: DefaultsKeys.feedbackLog)
        userDefaults.set("", forKey: DefaultsKeys.feedbackDescription)
        userDefaults.set("", forKey: DefaultsKeys.feedbackAuthor)
        fillFormFromDefaults()
//        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    func fillFormFromDefaults() {
        selectedFeedbackType.selectedSegmentIndex = userDefaults.integer(forKey: DefaultsKeys.feedbackType)
//        logFileSwitch.isOn = userDefaults.bool(forKey: DefaultsKeys.feedbackLog)
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
//        if section == 1 {
//            return "If you encountered an error in the application, it would be helpful to include the log files."
//        } else
        if section == LocalKeys.submitSection {
            if currentSubmissionStatus == .submitFailed {
                return "Submission Failed."
            } else if currentSubmissionStatus == .submitSuccessful {
                return "Submission Complete."
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
            currentSubmissionStatus = .sending
            tableView.reloadData()
            sender.isEnabled = false
            // Convert date
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: now)
            // Put message together
            var message = "New Message (\(dateString)):\n"
            message += "Type: \(selectedFeedbackType.selectedSegmentIndex)\n"
            message += "Message Text:\n\(descriptionTextView.text ?? "")\n"
            message += "Contact: \(contactTextField.text ?? "")"
            
            let feedbackQueue = DispatchQueue(label: "feedbackQueue", attributes: .concurrent)
            feedbackQueue.async {
                TelegramHelper.send(message: message, delegate: self)
            }
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
