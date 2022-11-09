//
//  TextEditViewController.swift
//  Repetition_2.12
//
//  Created by Marat Shagiakhmetov on 07.11.2022.
//

import UIKit

class TextViewController: UIViewController {
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var delegate: AddNewNoteDelegate!
    var note: Notebook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNote()
    }
    
    private func setupNote() {
        themeLabel.font = UIFont.systemFont(ofSize: 21)
        themeLabel.text = "Theme"
        descriptionLabel.font = UIFont.systemFont(ofSize: 21)
        descriptionLabel.text = "Description"
        
        themeTextField.delegate = self
        themeTextField.placeholder = "Type your topic"
        themeTextField.autocapitalizationType = .sentences
        themeTextField.returnKeyType = .next
        themeTextField.text = note.mainLabel
        
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderColor = CGColor(
            red: 140/255,
            green: 140/255,
            blue: 140/255,
            alpha: 1
        )
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.text = note.text
    }
}

extension TextViewController: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        note.mainLabel = textField.text ?? ""
//        delegate.rewrite(mainLabel: note.mainLabel, text: note.text)
        print("textOfTextField: " + note.mainLabel + "; " + "textOfTextView: " + note.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        note.text = textView.text ?? ""
//        delegate.rewrite(mainLabel: note.mainLabel, text: note.text)
        print("textOfTextField: " + note.mainLabel + "; " + "textOfTextView: " + note.text)
    }
}
