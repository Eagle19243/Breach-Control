//
//  BCBreachDetailCell.swift
//  Breach Control
//
//  Created by naga on 2/25/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit

class BCBreachDetailCell: UITableViewCell {
    
    @IBOutlet private weak var txtDesc: UILabel!
    
    var desc: String? {
        set {
            txtDesc.text = newValue
        }
        get {
            return txtDesc.text
        }
    }
    
    var is_read: Bool? {
        set {
            if newValue == true {
                txtDesc.font = UIFont.systemFont(ofSize: 13.0)
            } else {
                txtDesc.font = UIFont.boldSystemFont(ofSize: 13.0)
            }
        }
        get {
            return txtDesc.font == UIFont.systemFont(ofSize: 13.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
