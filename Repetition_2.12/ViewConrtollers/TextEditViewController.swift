//
//  TextEditViewController.swift
//  Repetition_2.12
//
//  Created by Marat Shagiakhmetov on 07.11.2022.
//

import UIKit

class TextEditViewController: UIViewController {
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var delegate: AddNewNoteDelegate!
    
    private var editMainLabel: String = ""
    private var editSecondLabel: String = ""
    private var editText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        newNote()
    }
    
    private func setupDesign() {
        themeLabel.font = UIFont.systemFont(ofSize: 21)
        themeLabel.text = "Theme"
        descriptionLabel.font = UIFont.systemFont(ofSize: 21)
        descriptionLabel.text = "Description"
        
        themeTextField.delegate = self
        themeTextField.placeholder = "Type your topic"
        themeTextField.autocapitalizationType = .sentences
        themeTextField.returnKeyType = .next
        
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderColor = CGColor(
            red: 140/255,
            green: 140/255,
            blue: 140/255,
            alpha: 1
        )
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.cornerRadius = 6
    }
    
    private func newNote() {
        let newNote = Notebook(
            mainLabel: editMainLabel,
            secondLabel: editSecondLabel,
            text: editText
        )
        delegate.saveNote(note: newNote)
    }
}

extension TextEditViewController: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editMainLabel = textField.text ?? ""
        delegate.rewrite(mainLabel: editMainLabel, text: editText)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        editText = textView.text ?? ""
        delegate.rewrite(mainLabel: editMainLabel, text: editText)
    }
}
