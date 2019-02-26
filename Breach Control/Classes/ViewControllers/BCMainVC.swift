//
//  BCMainVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import MBProgressHUD

class BCMainVC: UITabBarController, UITabBarControllerDelegate, BCBreachesVCDelegate, BCHomeVCDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        BCAPIManager.shared.getAllEmails { (objects, error) in
            if let objects = objects {
                emails = objects
                var count_unread_breaches = 0
                
                if emails.count == 0 {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                for (index, email) in emails.enumerated() {
                    BCAPIManager.shared.getBreachesForEmail(email: email, is_read: false, completion: { (breaches, error) in
                        if let breaches = breaches {
                            badge_counts.append(breaches.count)
                            count_unread_breaches += breaches.count
                        }
                        
                        if index == emails.count - 1 {
                            if let tabItems = self.tabBar.items, count_unread_breaches > 0 {
                                let tabItem = tabItems[2]
                                tabItem.badgeValue = String(count_unread_breaches)
                            }
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    })
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
        self.delegate = self
        let homeVC = self.viewControllers![0] as! BCHomeVC
        homeVC.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "BCAboutVC") as! BCAboutVC
            self.present(aboutVC, animated: true, completion: nil)
        } else if item.tag == 2 {
            let breachesVC = self.storyboard?.instantiateViewController(withIdentifier: "BCBreachesVC") as! BCBreachesVC
            breachesVC.delegate = self
            self.present(breachesVC, animated: true, completion: nil)
        }
    }
    
    func resetBadge() {
        var count_unread_breaches = 0
        
        for badge_count in badge_counts {
            count_unread_breaches += badge_count
        }
        
        if let tabItems = self.tabBar.items {
            if count_unread_breaches > 0 {
                tabItems[2].badgeValue = String(count_unread_breaches)
            } else {
                tabItems[2].badgeValue = nil
            }
        }
    }
    
    // MARK: - BCBreachesVCDelegate
    
    func onCloseButtonTouchUpInside() {
        self.resetBadge()
    }
    
    // MARK: - BCHomeVCDelegate
    
    func onEmailsUpdated() {
        self.resetBadge()
    }
    
    // MARK: - Delegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: BCAboutVC.self) || viewController.isKind(of: BCBreachesVC.self) {
            return false
        }
        
        return true
    }
}
