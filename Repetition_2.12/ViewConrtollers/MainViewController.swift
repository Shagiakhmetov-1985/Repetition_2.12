//
//  MainViewController.swift
//  Repetition_2.12
//
//  Created by Marat Shagiakhmetov on 07.11.2022.
//

import UIKit

protocol NewNoteDelegate {
    func saveNote(note: Notebook)
    func rewrite(mainLabel: String, text: String)
}

class MainViewController: UITableViewController {
    
    @IBOutlet weak var addNewNoteBarButton: UIBarButtonItem!
    
    private var notebook: [Notebook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchNotes()
    }
    
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
            textVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteNote(note: indexPath.row)
            notebook.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func setup() {
        navigationItem.title = "Заметки"
        tableView.rowHeight = 50
        addNewNoteBarButton.tintColor = UIColor(
            red: 220/255,
            green: 190/255,
            blue: 30/255,
            alpha: 1
        )
    }
    
    private func fetchNotes() {
        notebook = StorageManager.shared.fetchNotes()
    }
    
}

extension MainViewController: NewNoteDelegate {
    func saveNote(note: Notebook) {
        notebook.append(note)
        StorageManager.shared.saveNote(note: note)
        tableView.reloadData()
    }
    
    func rewrite(mainLabel: String, text: String) {
        let count = notebook.count - 1
        
        let currentDate = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.YYYY в HH:mm"
        
        notebook[count].mainLabel = mainLabel
        notebook[count].secondLabel = formatter.string(from: currentDate)
        notebook[count].text = text
        
        StorageManager.shared.rewriteNote(notes: notebook)
        tableView.reloadData()
    }
}
