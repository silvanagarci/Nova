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
    @IBOutlet weak var loginTherapistButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
 

    @IBAction func patientLoginButtonTapped(_ sender: Any) {
        navigateToMessagesVC()
        
    }
    
    @IBAction func therapistLoginButtonTapped(_ sender: Any) {
        navigateToPatientListVC()
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
        loginTherapistButton.layer.cornerRadius = 5
        loginPatientButton.layer.cornerRadius = 5
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245/255.0, green: 94/255.0, blue: 97/255.0, alpha: 2.0)
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
