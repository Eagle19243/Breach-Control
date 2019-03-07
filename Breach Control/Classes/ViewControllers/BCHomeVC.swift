//
//  BCHomeVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class BCHomeVC: BCBaseVC, BCBreachesVCDelegate {

    @IBOutlet fileprivate weak var tblEmails: UITableView!
    @IBOutlet weak var btnAbout: UIView!
    @IBOutlet weak var btnBreaches: UIView!
    @IBOutlet weak var txtBadge: UILabel!
    @IBOutlet weak var badgeContainer: UIView!
    
    fileprivate let addButtonHeight: CGFloat = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutTableView()
        
        txtBadge.superview?.layer.cornerRadius = txtBadge.frame.height / 2
        txtBadge.superview?.layer.masksToBounds = true
        txtBadge.superview?.clipsToBounds = true
        
        btnAbout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutButtonTouchUpInside)))
        btnBreaches.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(breachesButtonTouchUpInside)))
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        BCAPIManager.shared.getAllEmails { (objects, error) in
            if let objects = objects {
                emails = objects
                
                if emails.count == 0 {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                BCAPIManager.shared.getAllBreaches(is_read: false, completion: { (breaches, error) in
                    for email in emails {
                        var count_unread_breaches = 0
                        
                        if let breaches = breaches {
                            for breach in breaches {
                                if let obj_email = breach.email as? BCEmailModel,
                                    email == obj_email.email {
                                    count_unread_breaches += 1
                                }
                            }
                        }
                        
                        badge_counts.append(count_unread_breaches)
                    }
                    
                    self.tblEmails.reloadData()
                    self.layoutTableView()
                    self.updateBadge()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func monitorEmail(email: String, edited: Bool, row: Int?, lastEmail: String?) {
        if email.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Email address cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if !isValidEmail(email: email) {
            let alert = UIAlertController(title: "Error", message: "Invalid email address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if edited {
                emails[row!] = email
                badge_counts[row!] = 0
                BCAPIManager.shared.updateEmail(oldEmail: lastEmail!, newEmail: email) { (count, error) in
                    badge_counts[row!] = count ?? 0
                    self.updateBadge()
                }
            } else {
                emails.append(email)
                badge_counts.append(0)
                let row = badge_counts.count - 1
                BCAPIManager.shared.addEmail(email: email) { (count, error) in
                    badge_counts[row] = count ?? 0
                    self.updateBadge()
                }
            }
            
            self.tblEmails.reloadData()
            self.layoutTableView()
        }
    }
    
    func editEmail(email: String, row: Int) {
        let alert  = UIAlertController(title: "Update Email Address", message: "Enter an email address to be monitored", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.text = email
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.monitorEmail(email: alert.textFields![0].text ?? "", edited: true, row: row, lastEmail: email)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func updateBadge() {
        var count_unread_breaches = 0
        
        for badge_count in badge_counts {
            count_unread_breaches += badge_count
        }
        
        if count_unread_breaches > 0 {
            badgeContainer.isHidden = false
            txtBadge.text = String(count_unread_breaches)
        } else {
            badgeContainer.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @objc func addButtonTouchUpInside(_ sender: Any) {
        let alert  = UIAlertController(title: "Add Email Address", message: "Enter an email address to be monitored", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.monitorEmail(email: alert.textFields![0].text ?? "", edited: false, row: nil, lastEmail: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func aboutButtonTouchUpInside() {
        let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "BCAboutVC") as! BCAboutVC
        self.present(aboutVC, animated: true, completion: nil)
    }
    
    @objc func breachesButtonTouchUpInside() {
        let breachesVC = self.storyboard?.instantiateViewController(withIdentifier: "BCBreachesVC") as! BCBreachesVC
        breachesVC.delegate = self
        self.present(breachesVC, animated: true, completion: nil)
    }
    
    // MARK: - BCBreachesVCDelegate
    
    func onCloseButtonTouchUpInside() {
        self.updateBadge()
    }

}

extension BCHomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return addButtonHeight + 16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return addButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return emails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BCEmailCell") as! BCEmailCell
        cell.email = emails[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert  = UIAlertController(title: "Remove Email Address", message: "Do you want to remove the email address?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.deleteEmail(indexPath: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editEmail(email: emails[indexPath.row], row: indexPath.row)
    }
    
    private func deleteEmail(indexPath: IndexPath) {
        BCAPIManager.shared.deleteEmail(email: emails[indexPath.row]) { (success, error) in
        }
        
        emails.remove(at: indexPath.row)
        badge_counts.remove(at: indexPath.row)
        tblEmails.deleteRows(at: [indexPath], with: .fade)
        self.updateBadge()
        layoutTableView()
    }
    
    private func addButton() -> UIButton {
        let btnAdd = UIButton(type: .custom)
        let imageView = UIImageView(image: UIImage(named: "add"))
        btnAdd.addTarget(self, action: #selector(addButtonTouchUpInside(_:)), for: .touchUpInside)
        btnAdd.frame = CGRect(origin: .zero, size: CGSize(width: tblEmails.frame.width, height: addButtonHeight + 16))
        btnAdd.backgroundColor = self.view.backgroundColor
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: addButtonHeight, height: addButtonHeight))
        btnAdd.addSubview(imageView)
        imageView.center = btnAdd.center
        
        return btnAdd
    }
    
    fileprivate func layoutTableView() {
        let tabHeight: CGFloat = 49
        let topY: CGFloat = tblEmails.frame.origin.y
        let titleHeight: CGFloat = tblEmails.tableHeaderView?.frame.height ?? 0
        let spyglassHeight:CGFloat = 85
        
        var dy = (UIScreen.main.bounds.height - tabHeight - topY - titleHeight - addButtonHeight - CGFloat(emails.count * 40)) / 2 - spyglassHeight
        if dy < 0 { dy = 0 }
        tblEmails.contentInset = UIEdgeInsets(top: dy, left: 0, bottom: 0, right: 0)
    }
}
