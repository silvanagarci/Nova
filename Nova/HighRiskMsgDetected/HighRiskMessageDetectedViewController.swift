//
//  HighRiskMessageDetectedViewController.swift
//  Nova
//
//  Created by Max Dignan on 10/22/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import Foundation
import UIKit


class HighRiskMessageDetectedViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func callNumber(number: String) {
        if let url = NSURL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func callEmergency(_ sender: Any) {
        self.callNumber(number: "867-5309")
    }
    
    @IBAction func callTherapist(_ sender: Any) {
        self.callNumber(number: "867-5309")
    }
    
    @IBAction func callHotline(_ sender: Any) {
        self.callNumber(number: "867-5309")
    }
}
