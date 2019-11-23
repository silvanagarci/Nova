//
//  PatientProfileViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 9/3/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import UIKit
import Charts

class PatientProfileViewController: UIViewController {

//    @IBOutlet weak var focusTextField: UITextField!
//    @IBOutlet weak var frequencyTextField: UITextField!
//    @IBOutlet weak var patientDataButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var _lineChartView: LineChartView!
    
    @IBOutlet weak var _tableView: UITableView!
    
    var patientId = 0
    
    var conversations : [Conversation] = []
    
//    @IBAction func patientDataButtonTapped(_ sender: Any) {
//        let alertController = UIAlertController(title: "Patient's Report", message: " Patient has shown 21.2% anxiety and 57.5% stress levels in the past week." , preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "Thanks Nova!", style: .default, handler: nil)
//        alertController.addAction(defaultAction)
//
//        present(alertController, animated: true, completion: nil)
//    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        navigateToPatientListVC()
    }
    
    override func viewDidLoad() {
        configureVC()
        loadAndRenderAnxietyChart()
        setUpTableView()
        loadConversationsForPatient(patientId: self.patientId)
        super.viewDidLoad()
    }
    
    func configureVC() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 245/255.0, green: 94/255.0, blue: 97/255.0, alpha: 2.0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        saveButton.layer.cornerRadius = 5
//        patientDataButton.layer.cornerRadius = 5
        
//        let navItem = UINavigationItem(title: "Back")
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButtonTapped))
        
//        self.navigationController?.navigationBar.setItems([navItem], animated: false)
        
        self.saveButton.isHidden = true
        
    }
    
    func setUpTableView() {
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
    }
    
    func loadConversationsForPatient(patientId: Int) {
        BackendService.shared.getConversations(forPatientId: patientId, completion: {conversations in
            self.conversations = conversations
                
            self._tableView.reloadData()
        })
        

    }
        
    func navigateToPatientListVC() {
        let navigationController = UINavigationController(rootViewController: PatientListViewController())
        present(navigationController, animated: false, completion: nil)
    }
    
    func loadAndRenderAnxietyChart() {
        let anxietyValues = [4, 7, 3, 9, 1, 3, 10].sorted().reversed()
        
        BackendService.shared.getAnxiety(forUserId: 1, completion: {CHANGE_TO_anxiety_values in
            
            var i = 0
            let chartDataEntries : [ChartDataEntry] = anxietyValues.compactMap({ val in
                let entry = ChartDataEntry(x: Double(i), y: Double(val))
                i = i + 1 // i++ was blocked by compiler
                return entry
            })
            
            let line1 = LineChartDataSet(entries: chartDataEntries, label: "Anxiety")
            
            line1.colors = [UIColor.blue]
            
            let data = LineChartData()
            data.addDataSet(line1)
            
            self._lineChartView.data = data
            self._lineChartView.chartDescription?.text = "Anxiety"
        })
        

    }
    
    func loadAndShowConversationAt(conversationId: Int) {
        let convo : [String] = BackendService.shared.getConversationById(conversationId: conversationId)
        
        let alertController = UIAlertController(title: "Patient's Conversation", message: convo.joined(separator: "\n") , preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Thanks Nova!", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Hide keyboard
     */
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
//        frequencyTextField.resignFirstResponder()
//        focusTextField.resignFirstResponder()
    }
}

extension PatientProfileViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.65)
        
        cell.textLabel!.text = self.conversations[indexPath.row].dateCreated as! String
        
        return cell
    }
    

}

extension PatientProfileViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        loadAndShowConversationAt(conversationId: self.conversations[indexPath.row].id as! Int)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Conversations"
    }
}
