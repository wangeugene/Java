//
//  DatabaseManager.swift
//  bible
//
//  Created by euwang on 2/26/26.
//


import Foundation
import SQLite3

class DatabaseManager {

    static let shared = DatabaseManager()
    private var db: OpaquePointer?

    private init() {
        openDatabase()
    }

    private func getDatabasePath() -> String {

        let fileManager = FileManager.default

        let supportURL = try! fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        return supportURL.appendingPathComponent("bible.sqlite").path
    }

    private func copyDatabaseIfNeeded() {

        let fileManager = FileManager.default
        let dbPath = getDatabasePath()

        if !fileManager.fileExists(atPath: dbPath) {

            if let bundlePath = Bundle.main.path(forResource: "bible", ofType: "sqlite") {

                try? fileManager.copyItem(atPath: bundlePath, toPath: dbPath)
                print("Database copied to sandbox")

            } else {
                print("Database NOT found in bundle")
            }
        }
    }

    private func openDatabase() {

        copyDatabaseIfNeeded()

        if sqlite3_open(getDatabasePath(), &db) == SQLITE_OK {
            print("Database opened successfully")
        } else {
            print("Failed to open database")
        }
    }

    func getDB() -> OpaquePointer? {
        return db
    }
}