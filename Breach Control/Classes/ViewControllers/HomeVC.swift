//
//  HomeVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import PopupDialog
import MBProgressHUD

class HomeVC: BCBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func monitorEmail(email: String) {
        if email.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Email address cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func spyglassButtonTouchUpInside(_ sender: Any) {
        // Create a custom view controller
        let dialogVC = BCDialogVC(nibName: "BCDialogVC", bundle: nil)
        
        // Create a dialog
        let dialog = PopupDialog(viewController: dialogVC, buttonAlignment: .horizontal, transitionStyle: .bounceUp, preferredWidth: self.view.frame.width - 60.0, tapGestureDismissal: false, panGestureDismissal: false)
        
        // Create buttons
        let cancelButton = CancelButton(title: "CANCEL") {
        }
        let okButton = DefaultButton(title: "OK") {
            self.monitorEmail(email: dialogVC.emailTextField.text ?? "")
        }
        
        // Add buttons to dialog
        dialog.addButtons([cancelButton, okButton])
        
        // Present dialog
        present(dialog, animated: true, completion: nil)
    }

}
