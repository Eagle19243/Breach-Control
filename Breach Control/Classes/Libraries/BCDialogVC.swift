//
//  BCDialogVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit

class BCDialogVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }

}

extension BCDialogVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
    
}
