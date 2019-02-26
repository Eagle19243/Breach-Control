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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
