//
//  BCBreachesVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class BCBreachesVC: BCBaseVC {

    @IBOutlet fileprivate weak var btnClose: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailHeaderView: UIView!
    @IBOutlet weak var txtDetailHeader: UILabel!
    @IBOutlet fileprivate weak var tblBreaches: UITableView!
    @IBOutlet fileprivate weak var tblDetails: UITableView!
    
    fileprivate var details: [BCBreachModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topY = btnClose.frame.origin.y + 75.5
        detailView.frame = CGRect(origin: CGPoint(x: 0, y: topY), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - topY))
        detailView.layer.position.x = self.view.frame.width * 2
        tblBreaches.frame = CGRect(origin: CGPoint(x: 0, y: topY), size: CGSize(width: self.view.frame.width, height: topY))
        // TapGestureRecognizer
        detailHeaderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideDetailView)))
        
        
    }

    // MARK: - Actions
    
    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideDetailView() {
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.tblBreaches.layer.position.x = self.view.frame.width / 2
            self.detailView.layer.position.x = self.view.frame.width * 2
        })
        
        for breach in details {
            breach.is_read = true
            breach.saveInBackground()
        }
    }
    
}

extension BCBreachesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblBreaches {
            return emails.count
        } else {
            return details.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblBreaches {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BCBreachCell", for: indexPath) as! BCBreachCell
            cell.email = emails[indexPath.row]
            cell.badge = badge_counts[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BCBreachDetailCell", for: indexPath) as! BCBreachDetailCell
            cell.desc = details[indexPath.row].desc
            
            if !details[indexPath.row].is_read {
                cell.layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 240/255, alpha: 1.0).cgColor
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblBreaches {
            
            txtDetailHeader.text = emails[indexPath.row]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            BCAPIManager.shared.getBreachesForEmail(email: emails[indexPath.row], is_read: nil) { (breaches, error) in
                if let breaches = breaches {
                    for breach in breaches {
                        self.details.append(breach)
                    }
                    
                    self.tblDetails.reloadData()
                    self.tblBreaches.reloadData()
                    badge_counts[indexPath.row] = 0
                    
                    UIView.animate(withDuration: 0.5,
                                   animations: {
                        self.tblBreaches.layer.position.x = -self.view.frame.width / 2
                        self.detailView.layer.position.x = self.view.frame.width / 2
                    })
                }
                
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } else {
            
        }
    }
}
