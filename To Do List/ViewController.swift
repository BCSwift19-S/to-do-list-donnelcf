//
//  ViewController.swift
//  To Do List
//
//  Created by Christopher Donnelly on 2/9/19.
//  Copyright © 2019 Chris Donnelly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var defaultData = UserDefaults.standard
    var toDoArray = [String]()
    var toDoNotesArray = [String]()
//    var toDoArray = ["Learn Swift", "Build Apps", "Change the World!"]
//    var toDoNotesArray = ["I should do all of the exercises at the end of the chapters before the exams!", "Take my ideas to the school's venture competition and win the big check!", "Focus apps on empowerment for all, with a special bonus for users who are kind."]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        toDoArray = defaultData.stringArray(forKey: "toDoArray") ?? [String]()
        toDoNotesArray = defaultData.stringArray(forKey: "toDoNotesArray") ?? [String]()
        
    }
    
    func saveDefaultsData() {
        defaultData.set(toDoArray, forKey: "toDoArray")
        defaultData.set(toDoNotesArray, forKey:"toDoNotesArray")
    }
    
    //when user selects item to edit from main view controller, set destination to DetailViewController, find the index of the selected row, then pull the corresponding toDoItem and toDoNote from the arrays
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            let destination = segue.destination as! DetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destination.toDoItem = toDoArray[index]
            destination.toDoNotes = toDoNotesArray[index]
        } else{
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
//if the user saves a note, test whether it was a previously existing cell and update, or create a new cell for the new note
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue){
        let sourceViewController = segue.source as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            toDoArray[indexPath.row] = sourceViewController.toDoItem!
            toDoNotesArray[indexPath.row] = sourceViewController.toDoNotes!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            toDoArray.append(sourceViewController.toDoItem!)
            toDoNotesArray.append(sourceViewController.toDoNotes!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        saveDefaultsData()
    }
    //when the user selects the Edit button in the navigation bar on the main view controller
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            addBarButton.isEnabled = true
            editBarButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            addBarButton.isEnabled = false
            editBarButton.title = "Done"
        }
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        cell.detailTextLabel?.text = toDoNotesArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoArray.remove(at:indexPath.row)
            toDoNotesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveDefaultsData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoArray[sourceIndexPath.row]
        toDoArray.remove(at: sourceIndexPath.row)
        toDoArray.insert(itemToMove, at: destinationIndexPath.row)
        let notesToMove = toDoNotesArray[sourceIndexPath.row]
        toDoNotesArray.remove(at: sourceIndexPath.row)
        toDoNotesArray.insert(notesToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
}
