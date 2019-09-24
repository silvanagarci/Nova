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

    @IBOutlet weak var focusTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var patientDataButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var _lineChartView: LineChartView!
    
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
        loadAndRenderAnxietyChart()
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
    
    func loadAndRenderAnxietyChart() {
//        let anxietyValues = [4, 7, 3, 9, 1, 3, 10]
        
        BackendService.shared.getAnxiety(forUserId: 1, completion: {anxietyValues in
            
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
    
    /**
     Hide keyboard
     */
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        frequencyTextField.resignFirstResponder()
        focusTextField.resignFirstResponder()
    }
}
