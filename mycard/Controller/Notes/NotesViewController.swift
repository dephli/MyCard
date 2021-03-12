//
//  NotesViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/9/21.
//

import UIKit

class NotesViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!

// MARK: - Properties

    var viewModel: NotesViewModel!

// MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        notesTextView.text = viewModel.note
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bindNoteSaved = notesSaved
        viewModel.bindError = handleError
        customNavigationBar.shadowImage = UIImage()
        placeholderLabel.isHidden = !viewModel.note.isEmpty
        notesTextView.delegate = self
        let font = UIFont(name: "inter", size: 16)
        customNavigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: font!
        ]
    }

// MARK: - Actions

    @IBAction func saveButtonPressed(_ sender: Any) {
        viewModel.saveNote(note: notesTextView.text!)
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        notesSaved()
    }
// MARK: - Custom Methods

    func notesSaved() {
        self.presentationController?.delegate?.presentationControllerDidDismiss?(self.presentationController!)
        dismiss(animated: true, completion: nil)
    }

    func handleError(error: Error?) {
        if error == nil {
            self.alert(title: "Error", message: "Cannot save an empty note")
        } else {
            self.alert(title: "Error", message: error?.localizedDescription)
        }
    }

}
// MARK: - TextViewDelegate
extension NotesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !notesTextView.text.isEmpty
    }
}
