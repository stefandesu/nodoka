//
//  DebugListTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 01.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class DebugListTableViewController: ThemedTableViewController {

    var indexArray: [(key: String, value: Date)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        let index = MeditationSession.index
        indexArray = index.sorted { $0.value > $1.value }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.debugListCell, for: indexPath)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let session = MeditationSession.getSession(identifier: indexArray[indexPath.row].key) {
            let dateString = formatter.string(from: session.date)
            cell.textLabel?.text = "Date: \(dateString)"
            let minutes = Int(session.duration) / 60
            let minuteString = minutes > 0 ? "\(minutes) min. " : ""
            let seconds = Int(session.duration) % 60
            let secondString = seconds > 0 ? "\(seconds) sec." : ""
            cell.detailTextLabel?.text = "Duration: \(minuteString)\(secondString)"
        } else {
            let dateString = formatter.string(from: indexArray[indexPath.row].value)
            cell.textLabel?.text = "\(dateString)"
            cell.detailTextLabel?.text = "Could not load session."
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && indexArray.count == 0 {
            return "No sessions recorded."
        }
        return nil
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let identifier = indexArray[indexPath.row].key
            indexArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            MeditationSession.removeSession(identifier: identifier)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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
