//
//  FeedbackTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 03.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class FeedbackTableViewController: ThemedTableViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var logFileSwitch: UISwitch!
    @IBOutlet weak var selectedFeedbackType: UISegmentedControl!
    @IBOutlet weak var contactTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            // Text field
            return 128.0
        } else {
            return tableView.rowHeight
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        sender.setTitle("Submitting...", for: .normal)
        sender.isEnabled = false
        let feedbackQueue = DispatchQueue(label: "feedbackQueue", attributes: .concurrent)
        feedbackQueue.async {
            sleep(5)
            DispatchQueue.main.async {
                sender.setTitle("Submission Failed.", for: .normal)
            }
            sleep(3)
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
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
