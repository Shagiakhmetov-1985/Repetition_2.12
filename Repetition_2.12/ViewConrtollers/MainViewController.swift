//
//  MainViewController.swift
//  Repetition_2.12
//
//  Created by Marat Shagiakhmetov on 07.11.2022.
//

import UIKit

protocol AddNewNoteDelegate {
    func saveNote(note: Notebook)
    func rewrite(mainLabel: String, text: String)
}

class MainViewController: UITableViewController {
    
    private var notebook: [Notebook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchNotes()
    }
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notebook.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell
        let data = notebook[indexPath.row]
        
        cell.mainLabel.text = data.mainLabel
        cell.secondLabel.text = data.secondLabel
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let textEditVC = segue.destination as? TextEditViewController {
            textEditVC.delegate = self
        } else if let textVC = segue.destination as? TextViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let note = notebook[indexPath.row]
            textVC.note = note
        }
    }
    
    private func setup() {
        navigationItem.title = "Заметки"
        tableView.rowHeight = 50
    }
    
    private func fetchNotes() {
        notebook = StorageManager.shared.fetchNotes()
        print(notebook)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
//    @IBAction func unwind(for segue: UIStoryboardSegue) {
//        guard let textEditVC = segue.source as? TextEditViewController else { return }
//
//    }
}

extension MainViewController: AddNewNoteDelegate {
    func saveNote(note: Notebook) {
        notebook.append(note)
        StorageManager.shared.saveNote(note: note)
        tableView.reloadData()
    }
    
    func rewrite(mainLabel: String, text: String) {
        let count = notebook.count - 1
        
        let currentDate = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.YYYY"
//        print(notebook)
        notebook[count].mainLabel = mainLabel
        notebook[count].secondLabel = formatter.string(from: currentDate)
        notebook[count].text = text
        
        StorageManager.shared.rewriteNote(notes: notebook)
        tableView.reloadData()
    }
}
