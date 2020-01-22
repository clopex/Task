//
//  SignUpViewController.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setup() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func signUpTap(_ sender: UIButton) {
        guard let name = nameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if Util.isValidEmail(mail: email) {
            if isValid() {
                signUp(email, password, name)
            } else {
                nameTextField.layer.borderColor = UIColor.red.cgColor
            }
        } else {
            emailView.layer.borderColor = UIColor.red.cgColor
            showAlertWith("Email not valid!")
        }
    }
    
    private func signUp(_ email: String, _ password: String, _ name: String) {
        FirebaseManager.signUpUserWith(email, password, name) { [weak self] (success) in
            if success {
                let feedVc = FeedViewController()
                let navigationController = UINavigationController(rootViewController: feedVc)
                self?.present(navigationController, animated: true)
            } else {
                self?.showAlertWith("Error Signup!")
            }
        }
    }
    
    private func isValid() -> Bool {
        guard let name = nameTextField.text else {return false}
        guard let password = passwordTextField.text else {return false}
        var valid = true
        
        if name.isEmpty {
            valid = false
            nameView.layer.borderColor = UIColor.red.cgColor
        }
        if password.isEmpty {
            valid = false
            passwordView.layer.borderColor = UIColor.red.cgColor
        }
        return valid
    }
    
    @IBAction func signInTap(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            nameView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        case passwordTextField:
            passwordView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        case emailTextField:
            emailView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        default: break
        }
    }
}
