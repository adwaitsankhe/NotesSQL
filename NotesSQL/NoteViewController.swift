//
//  NoteViewController.swift
//  NotesSQL
//
//  Created by Adwait Y Sankhé on 4/18/20.
//  Copyright © 2020 Adwait Y Sankhé. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet weak var noteTextView: UITextView!
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.text = note.contents
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        note.contents = noteTextView.text
        NoteManager.shared.save(note: note)
    }
}
