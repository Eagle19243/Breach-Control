//
//  BCHomeVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import MBProgressHUD

class BCHomeVC: BCBaseVC {

    @IBOutlet fileprivate weak var tblEmails: UITableView!
    
    fileprivate let spyglassHeight: CGFloat = 50
    fileprivate var emails: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutTableView()
    }
    
    func monitorEmail(email: String, edited: Bool, row: Int?) {
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
            } else {
                emails.append(email)
            }
            
            tblEmails.reloadData()
            layoutTableView()
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
            self.monitorEmail(email: alert.textFields![0].text ?? "", edited: true, row: row)
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
    
    @objc func spyglassButtonTouchUpInside(_ sender: Any) {
        let alert  = UIAlertController(title: "Email Address", message: "Enter an email address to be monitored", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.monitorEmail(email: alert.textFields![0].text ?? "", edited: false, row: nil)
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
        return spyglassHeight + 16
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return searchButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return emails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BCEmailCell") as! BCEmailCell
        cell.email = emails[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editEmail(email: emails[indexPath.row], row: indexPath.row)
    }
    
    private func searchButton() -> UIButton {
        let btnSearch = UIButton(type: .custom)
        let imageView = UIImageView(image: UIImage(named: "spyglass"))
        btnSearch.addTarget(self, action: #selector(spyglassButtonTouchUpInside(_:)), for: .touchUpInside)
        btnSearch.frame = CGRect(origin: .zero, size: CGSize(width: tblEmails.frame.width, height: spyglassHeight + 16))
        btnSearch.backgroundColor = self.view.backgroundColor
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: spyglassHeight, height: spyglassHeight))
        btnSearch.addSubview(imageView)
        imageView.center = btnSearch.center
        return btnSearch
    }
    
    fileprivate func layoutTableView() {
        let tabHeight: CGFloat = 49
        let topY: CGFloat = tblEmails.frame.origin.y
        let titleHeight: CGFloat = tblEmails.tableHeaderView?.frame.height ?? 0
        let searchButtonHeight: CGFloat = spyglassHeight
        
        var dy = (UIScreen.main.bounds.height - tabHeight - topY - titleHeight - searchButtonHeight - CGFloat(emails.count * 40)) / 2
        if dy < 0 { dy = 0 }
        tblEmails.contentInset = UIEdgeInsets(top: dy, left: 0, bottom: 0, right: 0)
    }
}
