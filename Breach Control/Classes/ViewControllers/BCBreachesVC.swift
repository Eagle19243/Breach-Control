//
//  BCBreachesVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit

class BCBreachesVC: BCBaseVC {

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailHeaderView: UIView!
    @IBOutlet fileprivate weak var tblBreaches: UITableView!
    
    fileprivate var emails: [String] = ["test1@gmail.com", "test2@gmail.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.layer.position.x = self.view.frame.width * 2
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
    }
    
}

extension BCBreachesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BCBreachCell", for: indexPath) as! BCBreachCell
        cell.email = emails[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.tblBreaches.layer.position.x = -self.view.frame.width / 2
            self.detailView.layer.position.x = self.view.frame.width / 2
        })
    }
}
