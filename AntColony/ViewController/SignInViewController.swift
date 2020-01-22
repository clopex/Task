//
//  SignInViewController.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backArrow: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    var isLogout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setup() {
        if isLogout {
            backArrow.isHidden = true
        } else {
            backArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDismiss)))
        }
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func isValid() -> Bool {
        guard let name = emailTextField.text else {return false}
        guard let password = passwordTextField.text else {return false}
        var valid = true
        
        if name.isEmpty {
            valid = false
            emailView.layer.borderColor = UIColor.red.cgColor
        }
        if password.isEmpty {
            valid = false
            passwordView.layer.borderColor = UIColor.red.cgColor
        }
        return valid
    }
    
    @objc func tapDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInTap(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if Util.isValidEmail(mail: email) {
            if isValid() {
                sign(email, password)
            }
        } else {
            showAlertWith("Email not valid!")
            emailView.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    private func sign(_ email: String, _ password: String) {
        FirebaseManager.signInUserWith(email, password) { [weak self] (success, error) in
            if success {
                self?.callFeedVC()
            } else {
                if let err = error {
                    self?.showAlertWith(err.localizedDescription)
                    self?.view.endEditing(true)
                }
            }
        }
    }
    
    private func callFeedVC() {
        let feedVc = FeedViewController()
        let navigationController = UINavigationController(rootViewController: feedVc)
        self.present(navigationController, animated: true)
    }
    
    @IBAction func googleSignTap(_ sender: UIButton) {
        //Error: AppAuth for GoolgeSignin does not support Xcode10 so I am unable to implement this feature
    }
    
    @IBAction func facebookSignTap(_ sender: UIButton) {
        let dummyView = UIView()
        dummyView.backgroundColor = .white
        self.view.addSubview(dummyView)
        dummyView.frame = self.view.frame
        self.view.bringSubviewToFront(dummyView)
        startActivityIndicator()
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if error == nil {
                guard let token = AccessToken.current else {return}
                FirebaseManager.signWith(token.tokenString, completionBlock: { [weak self] (success, error) in
                    if success {
                        self?.callFeedVC()
                    } else {
                        if let err = error {
                            self?.showAlertWith(err.localizedDescription)
                        }
                    }
                })
            } else {
                if let err = error {
                    self.showAlertWith(err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func signUpTap(_ sender: UIButton) {
        if isLogout {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signUp = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
            let navController = UINavigationController(rootViewController: signUp)
            UIApplication.shared.keyWindow?.rootViewController = navController
        } else {
            self.dismissDetail()
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        case passwordTextField:
            passwordView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        default: break
        }
    }
}
