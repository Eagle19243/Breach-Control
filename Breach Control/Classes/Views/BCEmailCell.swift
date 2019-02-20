//
//  BCEmailCell.swift
//  Breach Control
//
//  Created by naga on 2/20/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit

class BCEmailCell: UITableViewCell {

    @IBOutlet private weak var txtEmail: UILabel!
    
    var email: String? {
        set {
            txtEmail.text = newValue
        }
        get {
            return txtEmail.text
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
