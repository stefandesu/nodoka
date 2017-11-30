//
//  MeditationSession.swift
//  MeditationTimer
//
//  Created by Stefan Peters on 30.11.17.
//  Copyright © 2017 Stefan Peters. All rights reserved.
//

import Foundation

struct MeditationSession: Codable {
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveDirectory = DocumentsDirectory.appendingPathComponent("sessions")
    
    var archiveURL: URL {
        return MeditationSession.ArchiveDirectory.appendingPathComponent(identifier).appendingPathExtension("plist")
    }
    
    var identifier: String
    var date: Date
    var duration: TimeInterval
    var savedToHealth: Bool
    
    init(date: Date, duration: TimeInterval) {
        self.date = date
        self.duration = duration
        self.savedToHealth = false
        self.identifier = UUID().uuidString
    }
    
    func save() {
        let propertyListEncoder = PropertyListEncoder()
        let encodedSession = try? propertyListEncoder.encode(self)
        do {
            try encodedSession?.write(to: archiveURL, options: .noFileProtection)
            print("apparently saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getSessions() -> [MeditationSession] {
        do {
            // Get the directory contents urls
            let directoryContents = try FileManager.default.contentsOfDirectory(at: ArchiveDirectory, includingPropertiesForKeys: nil, options: [])
            let propertyListDecoder = PropertyListDecoder()
            var sessions = [MeditationSession]()
            for file in directoryContents {
                if let data = try? Data(contentsOf: file), let session = try? propertyListDecoder.decode(MeditationSession.self, from: data) {
                    sessions.append(session)
                }
            }
            return sessions
        } catch {
            print(error.localizedDescription)
            return [MeditationSession]()
        }
    }
    
    static func deleteAllSessions() -> Bool {
        do {
            // Get the directory contents urls
            let directoryContents = try FileManager.default.contentsOfDirectory(at: ArchiveDirectory, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents {
                try FileManager.default.removeItem(at: file)
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
