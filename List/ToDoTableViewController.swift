//
//  ToDoTableViewController.swift
//  List
//
//  Created by Cesar Fernandez on 4/9/24.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = toDos[indexPath.row]
            toDo.isComplete.toggle()
            toDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
    

    var toDos = [ToDo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedToDos = ToDo.loadToDos() {
            toDos = savedToDos
        } else {
            toDos = ToDo.loadSampleToDos()
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "basic information"
//    }
  
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        
        let detailController = ToDoDetailTableViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return detailController
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        detailController?.toDo = toDos[indexPath.row]
        
        return detailController   
    }
    
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        
        if let toDo = sourceViewController.toDo {
            if let indexOfExistingToDo = toDos.firstIndex(of: toDo) {
                toDos[indexOfExistingToDo] = toDo
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingToDo, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                toDos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(toDos)
    }
    
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath) as! ToDoCell
        
        cell.delegate = self
        
        let toDo = toDos[indexPath.row]
        cell.titleLabel?.text = toDo.title
        cell.isCompleteButton.isSelected = toDo.isComplete
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    

    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
