//
//  BCNotificationModel.swift
//  Breach Control
//
//  Created by admin on 2/22/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import Parse

class BCNotificationModel: PFObject, PFSubclassing {
    
    @NSManaged var desc: String
    @NSManaged var is_read: Bool
    @NSManaged var email: PFObject
    @NSManaged var device: PFInstallation?
    
    class func parseClassName() -> String {
        return "Notification"
    }
    
    override init() {
        super.init()
        self.device = PFInstallation.current()
    }
}
