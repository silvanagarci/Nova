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
        
    @IBOutlet weak var loginPatientButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
 
    @IBAction func therapistLoginButtonTapped(_ sender: Any) {
        BackendService.shared.login(username: usernameTextField.text!, password: passwordTextField.text!, completion: { isLoggedIn, isDoctor, userId in
            
            if isLoggedIn {
                if isDoctor {
                    self.navigateToPatientListVC()
                } else {
                    self.navigateToMessagesVC()
                }
            } else {
                print("Couldn't login")
            }
        })
        
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
        passwordTextField.isSecureTextEntry = true
        loginPatientButton.layer.cornerRadius = 5
        self.navigationController?.navigationBar.barTintColor = kNovaColor
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
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
    
    /**
     Navigate to MessagesVC
     */
    func navigateToPatientListVC() {
        let navigationController = UINavigationController(rootViewController: PatientListViewController())
        present(navigationController, animated: false, completion: nil)
    }


}
