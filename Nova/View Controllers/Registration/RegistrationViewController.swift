//
//  RegistrationViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 8/29/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import UIKit
//import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        //Auth.auth().signInAnonymously() { (user, error) in
       // }
        navigateToMessagesVC()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    func configureVC() {
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        loginButton.layer.cornerRadius = 1
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 3/255.0, green: 5/255.0, blue: 25/255.0, alpha: 2.0)
        self.navigationController?.navigationBar.isTranslucent = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /**
     Hide keyboard
     */
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
    }
    
    /**
     Navigate to MessagesVC
     */
    func navigateToMessagesVC() {
        let navigationController = UINavigationController(rootViewController: ChatViewController())
        present(navigationController, animated: false, completion: nil)
    }


}
