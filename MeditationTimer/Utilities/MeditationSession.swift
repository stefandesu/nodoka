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
    static let IndexURL = DocumentsDirectory.appendingPathComponent("sessions").appendingPathExtension("plist")
    static var index: [String: Date] {
        let propertyListDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: IndexURL), let index = try? propertyListDecoder.decode([String: Date].self, from: data) {
            return index
        } else {
            // create empty index file
            let propertyListEncoder = PropertyListEncoder()
            let encodedIndex = try? propertyListEncoder.encode([String: Date]())
            do {
                try encodedIndex?.write(to: IndexURL, options: .noFileProtection)
            } catch {
                print(error.localizedDescription)
            }
            return [String: Date]()
        }
    }
    static func writeToIndex(session: MeditationSession) {
        var index = self.index
        index[session.identifier] = session.date
        // write to file
        let propertyListEncoder = PropertyListEncoder()
        let encodedIndex = try? propertyListEncoder.encode(index)
        do {
            try encodedIndex?.write(to: IndexURL, options: .noFileProtection)
        } catch {
            print(error.localizedDescription)
        }
    }
    static func removeFromIndex(identifier: String) {
        var index = self.index
        index.removeValue(forKey: identifier)
        // write to file
        let propertyListEncoder = PropertyListEncoder()
        let encodedIndex = try? propertyListEncoder.encode(index)
        do {
            try encodedIndex?.write(to: IndexURL, options: .noFileProtection)
        } catch {
            print(error.localizedDescription)
        }
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
            MeditationSession.writeToIndex(session: self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getAllSessions() -> [MeditationSession] {
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
    
    static func getNumberOfSessions() -> Int {
        do {
            // Get the directory contents urls
            let directoryContents = try FileManager.default.contentsOfDirectory(at: ArchiveDirectory, includingPropertiesForKeys: nil, options: [])
            return directoryContents.count
        } catch {
            print(error.localizedDescription)
            return -1
        }
    }
    
    static func getSessions() -> [String] {
        do {
            // Get the directory contents urls
            let directoryContents = try FileManager.default.contentsOfDirectory(at: ArchiveDirectory, includingPropertiesForKeys: nil, options: [])
            var sessions = [String]()
            for file in directoryContents {
                sessions.append(file.lastPathComponent)
            }
            return sessions
        } catch {
            print(error.localizedDescription)
            return [String]()
        }
    }
    
    static func getSession(identifier: String) -> MeditationSession? {
        let file = ArchiveDirectory.appendingPathComponent(identifier).appendingPathExtension("plist")
        let propertyListDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: file), let session = try? propertyListDecoder.decode(MeditationSession.self, from: data) {
            return session
        } else {
            return nil
        }
    }
    static func removeSession(identifier: String) {
        // remove file from disk
        let file = ArchiveDirectory.appendingPathComponent(identifier).appendingPathExtension("plist")
        try? FileManager.default.removeItem(at: file)
        // remove from index
        removeFromIndex(identifier: identifier)
    }
    
    static func deleteAllSessions() {
        for identifier in getSessions() {
            removeSession(identifier: identifier)
        }
        for (identifier, _) in index {
            removeSession(identifier: identifier)
        }
    }
}
