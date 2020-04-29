//
//  NoteManager.swift
//  NotesSQL
//
//  Created by Adwait Y Sankhé on 4/18/20.
//  Copyright © 2020 Adwait Y Sankhé. All rights reserved.
//

import Foundation
import SQLite3

struct Note {
    let id: Int
    var contents: String
}

class NoteManager {
    private init() { }
    
    static let shared = NoteManager()
    private var database: OpaquePointer!
    
    private func connect() {
        if database != nil { return }
        
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (contents TEXT)", nil, nil, nil) == SQLITE_OK {
                    
                } else {
                    print("Error: Could not create notes table")
                }
            } else {
                print("Error: Could not connect to database")
            }
        } catch let error {
            print("Error: Could not create database \(error)")
        }
    }
    
    func create() -> Int {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "INSERT INTO notes (contents) VALUES ('New note')", -1, &statement, nil) != SQLITE_OK {
            print("Error: Could not create query")
            return -1
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error: Could not insert note")
            return -1
        }
        
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAllNotes() -> [Note] {
        connect()
        var result: [Note] = []
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "SELECT rowid, contents FROM notes", -1, &statement, nil) != SQLITE_OK {
            print("Error: Could not retrieve note from table")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Note(id: Int(sqlite3_column_int(statement, 0)), contents: String(cString: sqlite3_column_text(statement, 1))))
        }
        
        sqlite3_finalize(statement)
        return result
    }
    
    func save(note: Note) {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "UPDATE notes SET contents = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error: Could not create update statement")
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: note.contents).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error: Could not update note")
        }
        
        sqlite3_finalize(statement)
    }
    
    func remove(note: Note) {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "DELETE FROM notes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error: Could not create delete statement")
        }
        
        sqlite3_bind_int(statement, 1, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error: Could not delete note")
        }
        
        sqlite3_finalize(statement)
    }
}
