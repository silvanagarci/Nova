//
//  PatientListViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 9/3/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import UIKit

class PatientListViewController: UIViewController {
    
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var patientList = ["Stephen Boxwell", "Carter"]
    
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        navigateToRegistrationVC()
    }
    
    override func viewDidLoad() {
        configureVC()
        super.viewDidLoad()

    }
    
    func configureVC() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
        tableView.canCancelContentTouches = false
        tableView.isUserInteractionEnabled = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        logOutButton.layer.cornerRadius = 5
        
    }
    
    func navigateToPatientProfileVC() {
        let navigationController = UINavigationController(rootViewController: PatientProfileViewController())
        present(navigationController, animated: false, completion: nil)
    }
    
    func navigateToRegistrationVC() {
        let navigationController = UINavigationController(rootViewController: RegistrationViewController())
        present(navigationController, animated: false, completion: nil)
    }

}
extension PatientListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! UITableViewCell
        
        //adding the item to table row
        cell.textLabel?.text = patientList[indexPath.row]
        
        return cell
    }
    
}

extension PatientListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToPatientProfileVC()
        
    }
    
}
