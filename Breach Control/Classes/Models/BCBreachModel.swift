//
//  BCBreachModel.swift
//  Breach Control
//
//  Created by naga on 2/25/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import Parse

class BCBreachModel: PFObject, PFSubclassing {
    
    @NSManaged var desc: String
    @NSManaged var email: PFObject
    @NSManaged var device: PFInstallation?
    @NSManaged var is_read: Bool
    
    class func parseClassName() -> String {
        return "Breach"
    }
}
