//
//  DetailViewController.swift
//  To Do List
//
//  Created by Christopher Donnelly on 2/9/19.
//  Copyright © 2019 Chris Donnelly. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var toDoField: UITextField!
    @IBOutlet weak var toDoNotesView: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    var toDoItem: String!
    var toDoNotes: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDoItem = toDoItem {
            toDoField.text = toDoItem
            self.navigationItem.title = "Edit To Do Item"
        } else {
            self.navigationItem.title = "Add New To Do Item"
        }
        
        if let toDoNotes = toDoNotes {
            toDoNotesView.text = toDoNotes
        }
        
        enableDisableSaveBarButton()
        toDoField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave"{
            toDoItem = toDoField.text
            toDoNotes = toDoNotesView.text
        }
    }
    
    func enableDisableSaveBarButton() {
        if let toDoLength = toDoField.text?.count, toDoLength > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func toDoFieldEditingChanged(_ sender: UITextField) {
        enableDisableSaveBarButton()
    }
    
}
