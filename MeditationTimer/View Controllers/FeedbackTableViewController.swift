//
//  FeedbackTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 03.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class FeedbackTableViewController: ThemedTableViewController, TelegramHelperDelegate, UITextViewDelegate {
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
    @IBOutlet weak var logFileSwitch: UISwitch!
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
        logFileSwitch.isOn = userDefaults.bool(forKey: DefaultsKeys.feedbackLog)
        contactTextField.text = userDefaults.string(forKey: DefaultsKeys.feedbackAuthor)
        descriptionTextView.text = userDefaults.string(forKey: DefaultsKeys.feedbackDescription)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            // Text field
            return 128.0
        } else {
            return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 4 else { return nil }
        if currentSubmissionStatus == .submitFailed {
            return "Submission Failed."
        } else if currentSubmissionStatus == .submitSuccessful {
            return "Submission Complete."
        }
        return nil
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        currentSubmissionStatus = .sending
        tableView.reloadData()
        sender.isEnabled = false
        // Put message together
        var message = "New Message (\(Date()):\n"
        message += "Type: \(selectedFeedbackType.selectedSegmentIndex)\n"
        message += "Message Text:\n\(descriptionTextView.text ?? "")\n"
        message += "Contact: \(contactTextField.text ?? "")"
        
        let feedbackQueue = DispatchQueue(label: "feedbackQueue", attributes: .concurrent)
        feedbackQueue.async {
            TelegramHelper.send(message: message, delegate: self)
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
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
