//
//  BCEmailModel.swift
//  Breach Control
//
//  Created by naga on 2/22/19.
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
}
