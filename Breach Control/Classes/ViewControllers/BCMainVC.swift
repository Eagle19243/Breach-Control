//
//  BCMainVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit

class BCMainVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "BCAboutVC") as! BCAboutVC
            self.present(aboutVC, animated: true, completion: nil)
        } else if item.tag == 2 {
            let breachesVC = self.storyboard?.instantiateViewController(withIdentifier: "BCBreachesVC") as! BCBreachesVC
            self.present(breachesVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Delegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: BCAboutVC.self) || viewController.isKind(of: BCBreachesVC.self) {
            return false
        }
        
        return true
    }
}
