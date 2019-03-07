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
    
    var name: String = ""
    
    var desc: String? {
        set {
            guard let newValue = newValue else {
                return
            }
            
            txtDesc.text = "\(name): \(newValue)"
            
            for conditionalString in ConditionalStrings {
                txtDesc.set(textColor: UIColor.red, range: txtDesc.range(string: conditionalString))
                txtDesc.set(font: UIFont.boldSystemFont(ofSize: 13.0), range: txtDesc.range(string: conditionalString))
            }
            
            txtDesc.set(font: UIFont.boldSystemFont(ofSize: 13.0), range: txtDesc.range(string: name))
        }
        get {
            return txtDesc.text
        }
    }
    
    var is_read: Bool? {
        set {
            if newValue == true {
                self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                self.backgroundColor = UIColor(red: 222/255, green: 249/255, blue: 248/255, alpha: 1.0)
            }
        }
        get {
            return self.backgroundColor == UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
