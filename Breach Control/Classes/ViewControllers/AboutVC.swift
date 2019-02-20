//
//  AboutVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit

class AboutVC: BCBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
