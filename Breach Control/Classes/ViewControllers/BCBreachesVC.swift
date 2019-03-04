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

protocol BCBreachesVCDelegate {
    func onCloseButtonTouchUpInside()
}

class BCBreachesVC: BCBaseVC {

    @IBOutlet fileprivate weak var btnClose: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailHeaderView: UIView!
    @IBOutlet weak var txtDetailHeader: UILabel!
    @IBOutlet fileprivate weak var tblBreaches: UITableView!
    @IBOutlet fileprivate weak var tblDetails: UITableView!
    
    var delegate:BCBreachesVCDelegate?
    
    fileprivate var details: [BCBreachModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds.size
        var topLayoutY: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topLayoutY = window?.safeAreaInsets.top ?? 0.0
        }
        
        let breachesRect = CGRect(x: 0,
                                  y: topLayoutY + 95.5,
                                  width: screenSize.width,
                                  height: screenSize.height - topLayoutY - 95.5)
        tblBreaches.frame = breachesRect
        
        detailView.frame = breachesRect
        detailView.layer.position.x = self.view.frame.width * 2
        
        tblDetails.rowHeight = UITableView.automaticDimension
        tblDetails.estimatedRowHeight = 250
        
        // TapGestureRecognizer
        detailHeaderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideDetailView)))
        
        
    }

    // MARK: - Actions
    
    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.onCloseButtonTouchUpInside()
        }
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
            cell.is_read = details[indexPath.row].is_read
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblBreaches {
            
            txtDetailHeader.text = emails[indexPath.row]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.details.removeAll()
            
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
