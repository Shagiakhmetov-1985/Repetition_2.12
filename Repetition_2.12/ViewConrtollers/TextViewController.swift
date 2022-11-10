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
    
    var delegate: NewNoteDelegate!
    var note: Notebook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNote()
        setupTextView()
    }
    
    private func setupNote() {
        navigationController?.navigationBar.tintColor = UIColor(
            red: 220/255,
            green: 190/255,
            blue: 30/255,
            alpha: 1
        )
        
        themeLabel.font = UIFont.systemFont(ofSize: 21)
        themeLabel.text = "Theme"
        descriptionLabel.font = UIFont.systemFont(ofSize: 21)
        descriptionLabel.text = "Description"
        
        themeTextField.delegate = self
        themeTextField.placeholder = "Type your topic"
        themeTextField.autocapitalizationType = .sentences
        themeTextField.returnKeyType = .next
        themeTextField.layer.borderWidth = 1
        themeTextField.layer.cornerRadius = 6
        themeTextField.layer.borderColor = CGColor(
            red: 110/255,
            green: 110/255,
            blue: 110/255,
            alpha: 1
        )
        themeTextField.text = note.mainLabel
        
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderColor = CGColor(
            red: 110/255,
            green: 110/255,
            blue: 110/255,
            alpha: 1
        )
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.textContainerInset = UIEdgeInsets(
            top: 10,
            left: 3,
            bottom: 10,
            right: 3
        )
        descriptionTextView.text = note.text
    }
    
    private func setupTextView() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTextView),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTextView),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func updateTextView(value: Notification) {
        let userInfo = value.userInfo
        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = view.convert(getKeyboardRect, to: view.window)
        
        if value.name == UIResponder.keyboardWillHideNotification {
            descriptionTextView.contentInset = UIEdgeInsets.zero
        } else {
            descriptionTextView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardFrame.height,
                right: 0
            )
            descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset
        }
        
        descriptionTextView.scrollRangeToVisible(descriptionTextView.selectedRange)
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
        delegate.rewrite(mainLabel: note.mainLabel, text: note.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        note.text = textView.text ?? ""
        delegate.rewrite(mainLabel: note.mainLabel, text: note.text)
    }
}
