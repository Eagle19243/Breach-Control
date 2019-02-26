//
//  BCBreachCell.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit

class BCBreachCell: UITableViewCell {

    @IBOutlet private weak var txtEmail: UILabel!
    @IBOutlet private weak var txtBadge: UILabel!
    
    var email: String? {
        set {
            txtEmail.text = newValue
        }
        get {
            return txtEmail.text
        }
    }
    
    var badge: Int {
        set {
            if newValue > 0 {
                txtBadge.text = String(newValue)
                txtBadge.superview?.isHidden = false
            } else {
                txtBadge.superview?.isHidden = true
            }
        }
        get {
            if let badgeString = txtEmail.text {
                return Int(badgeString) ?? 0
            } else {
                return 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtBadge.superview?.layer.cornerRadius = txtBadge.frame.height / 2
        txtBadge.superview?.layer.masksToBounds = true
        txtBadge.superview?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
