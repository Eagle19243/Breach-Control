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

protocol BCHomeVCDelegate {
    func onEmailsUpdated()
}

class BCHomeVC: BCBaseVC {

    @IBOutlet fileprivate weak var tblEmails: UITableView!
    
    fileprivate let addButtonHeight: CGFloat = 35
    var delegate:BCHomeVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        BCAPIManager.shared.getAllEmails { (objects, error) in
            if let objects = objects {
                emails = objects
                self.tblEmails.reloadData()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            self.layoutTableView()
        }
        
        self.layoutTableView()
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
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            if edited {
                emails[row!] = email
                BCAPIManager.shared.updateEmail(oldEmail: lastEmail!, newEmail: email) { (count, error) in
                    badge_counts[row!] = count ?? 0
                    self.delegate?.onEmailsUpdated()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tblEmails.reloadData()
                    self.layoutTableView()
                }
            } else {
                emails.append(email)
                BCAPIManager.shared.addEmail(email: email) { (count, error) in
                    badge_counts.append(count ?? 0)
                    self.delegate?.onEmailsUpdated()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tblEmails.reloadData()
                    self.layoutTableView()
                }
            }
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
        self.delegate?.onEmailsUpdated()
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
