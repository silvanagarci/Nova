//
//  PatientProfileViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 9/3/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import UIKit

class PatientProfileViewController: UIViewController {

    
    @IBOutlet weak var patientDataButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var focusTextField: UITextField!
    
    
    
    @IBAction func patientDataButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Patient's Report", message: " Patient has shown 21.2% anxiety and 57.5% stress levels in the past week." , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Thanks Nova!", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        navigateToPatientListVC()
    }
    
    override func viewDidLoad() {
        configureVC()
        super.viewDidLoad()
    }
    
    
    
    func configureVC() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245/255.0, green: 94/255.0, blue: 97/255.0, alpha: 2.0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        saveButton.layer.cornerRadius = 5
        patientDataButton.layer.cornerRadius = 5
        
    }
        
    func navigateToPatientListVC() {
        let navigationController = UINavigationController(rootViewController: PatientListViewController())
        present(navigationController, animated: false, completion: nil)
    }
    
    /**
     Hide keyboard
     */
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        frequencyTextField.resignFirstResponder()
        focusTextField.resignFirstResponder()
    }
}
