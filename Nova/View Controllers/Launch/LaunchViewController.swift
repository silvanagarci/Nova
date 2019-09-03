//
//  LaunchViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 8/29/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigateToRegistrationVC()
    }
    
    /**
     Navigate to Registration VC
     */
    func navigateToRegistrationVC() {
        let navigationController = UINavigationController(rootViewController: RegistrationViewController())
        present(navigationController, animated: false, completion: nil)
    }


}

