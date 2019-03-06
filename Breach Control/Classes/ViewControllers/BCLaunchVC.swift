//
//  BCLaunchVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import Pulsator

class BCLaunchVC: BCBaseVC {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var spyglassImageView: UIImageView!
    
    let pulsator = Pulsator()
    let spyglassHeight: CGFloat = 85
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pulse annimation for spyglass
        pulsator.numPulse = 4
        pulsator.radius = 120.0
        pulsator.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 0.8).cgColor
        spyglassImageView.layer.superlayer?.insertSublayer(pulsator, below: spyglassImageView.layer)
        pulsator.start()
        
        // perform(#selector(self.gotoMainVC), with: nil, afterDelay: 3)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoMainVC)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.layoutIfNeeded()
        pulsator.position = CGPoint(x: spyglassImageView.frame.origin.x + spyglassHeight / 2 - 3,
                                    y: spyglassImageView.frame.origin.y + spyglassHeight / 2 - 3)
    }
    
    @objc func gotoMainVC() {
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "BCMainVC") as! BCMainVC
        show(mainVC, sender: self)
    }
}
