//
//  DebugListTableViewController.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 01.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import UIKit

class DebugListTableViewController: ThemedTableViewController {

    var data: [[MeditationSession]] = []
    var titles: [String] = []
//    var sectionIndexTitles: [String] = []
//    var sectionIndexSections: [Int] = []
    var durationSums: [TimeInterval] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.rightBarButtonItem = self.editButtonItem

        let index = MeditationSession.index
        let indexArray = index.sorted { $0.value > $1.value }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
//        let shortDateFormatter = DateFormatter()
//        shortDateFormatter.locale = Locale(identifier: "en_GB")
//        shortDateFormatter.setLocalizedDateFormatFromTemplate("MM yyyy")
//        let yearFormatter = DateFormatter()
//        yearFormatter.locale = Locale(identifier: "en_GB")
//        yearFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        var currentMonth = ""
//        var currentYear = ""
//        var sectionIndexTitlesYear: [String] = []
//        var sectionIndexSectionsYear: [Int] = []
        var currentDurationSum: TimeInterval = 0
        for array in indexArray {
            if let session = MeditationSession.getSession(identifier: array.key) {
                let month = dateFormatter.string(from: session.date)
//                let year = yearFormatter.string(from: session.date)
                if currentMonth != month {
                    titles.append(month)
//                    sectionIndexTitles.append(shortDateFormatter.string(from: session.date))
                    data.append([MeditationSession]())
                    if !currentMonth.isEmpty {
                        durationSums.append(currentDurationSum)
                        currentDurationSum = 0
                    }
                    currentMonth = month
//                    if currentYear != year {
//                        sectionIndexTitlesYear.append(year)
//                        sectionIndexSectionsYear.append(sectionIndexTitles.count-1)
//                        currentYear = year
//                    }
                }
                data[data.endIndex-1].append(session)
                currentDurationSum += session.duration
            }
        }
        durationSums.append(currentDurationSum)
        
        // Section indexes
//        if sectionIndexTitles.count <= 24 {
//            sectionIndexSections = (0..<sectionIndexTitles.count).map { $0 }
//        } else {
//            sectionIndexTitles = sectionIndexTitlesYear
//            sectionIndexSections = sectionIndexSectionsYear
//        }
        
        navigationItem.title = "History"
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.debugListCell, for: indexPath)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("  MMMMd yyyy - HH:mm")
        
        let session = data[indexPath.section][indexPath.row]
        let dateString = dateFormatter.string(from: session.date)
        cell.detailTextLabel?.text = "\(dateString)"
        let hours = Int(session.duration) / 3600
        let hourString = hours > 0 ? "\(hours) Hour" + (hours > 1 ? "s " : " ") : ""
        let minutes = (Int(session.duration) - hours*3600) / 60
        let minuteString = minutes > 0 ? "\(minutes) Minute" + (minutes > 1 ? "s " : " ") : ""
        let seconds = Int(session.duration) % 60
        let secondString = seconds > 0 ? "\(seconds) Second" + (seconds > 1 ? "s" : "") : ""
        cell.textLabel?.text = "\(hourString)\(minuteString)\(secondString)"
        cell.selectionStyle = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && data.count == 0 {
            return "No sessions recorded."
        }
        return "\(titles[section]) (\(data[section].count) sessions)"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if data.count > 0 {
            let duration = durationSums[section]
            let hours = Int(duration) / 3600
            let hourString = hours > 0 ? "\(hours) Hour" + (hours > 1 ? "s " : " ") : ""
            let minutes = (Int(duration) - hours*3600) / 60
            let minuteString = minutes > 0 ? "\(minutes) Minute" + (minutes > 1 ? "s " : " ") : ""
            let seconds = Int(duration) % 60
            let secondString = seconds > 0 ? "\(seconds) Second" + (seconds > 1 ? "s" : "") : ""
            return "Total: \(hourString)\(minuteString)\(secondString)"
        }
        return nil
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            let session = data[indexPath.section][indexPath.row]
            data[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            durationSums[indexPath.section] -= session.duration
            let reloadSection: Bool
            if data[indexPath.section].count == 0 {
                data.remove(at: indexPath.section)
                titles.remove(at: indexPath.section)
                durationSums.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .fade)
                reloadSection = false
            } else {
                reloadSection = true
            }
            MeditationSession.removeSession(identifier: session.identifier)
            tableView.endUpdates()
            if reloadSection {
                // Delay this to avoid animation glitches
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) {
                    self.tableView.reloadSections([indexPath.section], with: .none)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return sectionIndexTitles
//    }
//
//    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return sectionIndexSections[index]
//    }

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
