//
//  BCLaunchVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit

class BCLaunchVC: BCBaseVC {

    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var spyglassImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       usingSpringWithDamping: 0.25,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
            self.logoImageView.layer.position.x = 30.0
            self.spyglassImageView.layer.position.x = 200.0
        })
        
        perform(#selector(self.gotoMainVC), with: nil, afterDelay: 3)
    }
    
    @objc func gotoMainVC() {
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "BCMainVC") as! BCMainVC
        show(mainVC, sender: self)
    }
}
