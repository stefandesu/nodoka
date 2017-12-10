//
//  TelegramHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 03.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation

enum FeedbackStatus: Int {
    case notSubmitted, submitting, submitSuccessful, submitFailed
}

protocol TelegramHelperDelegate {
    func telegramResponse(success: Bool)
}

class FeedbackHelper: TelegramHelperDelegate {
    static let shared = FeedbackHelper()
    let userDefaults = UserDefaults.standard
    var delegate: TelegramHelperDelegate?
    let feedbackQueue = DispatchQueue(label: "feedbackQueue", attributes: .concurrent)
    var currentlySending = false
    
    init() {
        
    }
    
    func send() {
        userDefaults.set(FeedbackStatus.submitting.rawValue, forKey: DefaultsKeys.feedbackStatus)
        currentlySending = true
        // Construct message out of user defaults
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        // Put message together
        var message = "New Message (\(dateString)):\n"
        message += "Type: \(userDefaults.integer(forKey: DefaultsKeys.feedbackType))\n"
        message += "Message Text:\n\(userDefaults.string(forKey: DefaultsKeys.feedbackDescription) ?? "")\n"
        message += "Contact: \(userDefaults.string(forKey: DefaultsKeys.feedbackAuthor) ?? "")"
        
        feedbackQueue.async {
            sleep(5)
            TelegramHelper.send(message: message, delegate: self)
        }
    }
    
    func telegramResponse(success: Bool) {
        currentlySending = false
        // Set feedback status in user defaults
        userDefaults.set(success ? FeedbackStatus.submitSuccessful.rawValue : FeedbackStatus.submitFailed.rawValue, forKey: DefaultsKeys.feedbackStatus)
        if success {
            resetDefaults()
        }
        // Forward response to current delegate
        delegate?.telegramResponse(success: success)
    }
    
    func resetDefaults() {
        userDefaults.set(0, forKey: DefaultsKeys.feedbackType)
        userDefaults.set(false, forKey: DefaultsKeys.feedbackLog)
        userDefaults.set("", forKey: DefaultsKeys.feedbackDescription)
        userDefaults.set("", forKey: DefaultsKeys.feedbackAuthor)
    }
}
//userDefaults.set(true, forKey: DefaultsKeys.feedbackNotSent)

class TelegramHelper {
    static let endpointURL = URL(string: "https://api.telegram.org/bot***REMOVED***/sendMessage")
    
    static func send(message: String, delegate: TelegramHelperDelegate?) {
        guard let endpointURL = endpointURL else { delegate?.telegramResponse(success: false); return }
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        let body: [String: String] = ["chat_id": "14618571", "text": message]
        let jsonBody: Data
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Error: cannot create JSON from todo")
            delegate?.telegramResponse(success: false)
            return
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST")
                print(error ?? "...")
                delegate?.telegramResponse(success: false)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                delegate?.telegramResponse(success: false)
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(
                    with: responseData,
                    options: []) as? [String: Any] else {
                        print("Could not get JSON from responseData as dictionary")
                        return
                    }
                print("The result is: " + jsonResponse.description)
                delegate?.telegramResponse(success: true)
                
            } catch  {
                print("error parsing response from POST")
                delegate?.telegramResponse(success: false)
                return
            }
        }
        task.resume()
    }
}
