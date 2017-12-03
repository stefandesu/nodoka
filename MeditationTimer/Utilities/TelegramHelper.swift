//
//  TelegramHelper.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 03.12.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation

protocol TelegramHelperDelegate {
    func telegramResponse(success: Bool)
}

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
