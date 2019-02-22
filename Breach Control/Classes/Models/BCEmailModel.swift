//
//  BCEmailModel.swift
//  Breach Control
//
//  Created by admin on 2/22/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import Parse

class BCEmailModel: PFObject, PFSubclassing {

    @NSManaged var email: String
    @NSManaged var device: PFInstallation?
    
    class func parseClassName() -> String {
        return "Email"
    }
    
    override init() {
        super.init()
        self.device = PFInstallation.current()
    }
}
