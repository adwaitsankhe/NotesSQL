//
//  ViewController.swift
//  NotesSQL
//
//  Created by Adwait Y Sankhé on 4/18/20.
//  Copyright © 2020 Adwait Y Sankhé. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes: [Note] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @IBAction func createNoteTapped() {
        _ = NoteManager.shared.create()
        reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].contents
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            _ = NoteManager.shared.remove(note: notes[indexPath.row])
        }
    }
    
    private func reloadData() {
        notes = NoteManager.shared.getAllNotes()
//        notes = notes.reversed()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue", let vc = segue.destination as? NoteViewController {
            vc.note = notes[tableView.indexPathForSelectedRow?.row ?? 0]
        }
    }
}
