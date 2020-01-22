//
//  PostViewController.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {

    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.delegate = self
        postTextView.becomeFirstResponder()
    }
    
    @IBAction func savePostTap(_ sender: UIButton) {
        postTextView.resignFirstResponder()
        guard let postText = postTextView.text else {return}
        FirebaseManager.post(postText) { [weak self] (success, error) in
            if success {
                self?.dismiss(animated: true)
            } else {
                if let err = error {
                    self?.showAlertWith(err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func closeTap(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true)
    }
}

extension PostViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !text.isEmpty {
            postBtn.isEnabled = true
            postBtn.alpha = 1
            return true
        } else if textView.text.isEmpty {
            postBtn.isEnabled = false
            postBtn.alpha = 0.5
            return false
        }
        
        return true
    }
}
