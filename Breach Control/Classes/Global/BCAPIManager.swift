//
//  BCAPIManager.swift
//  Breach Control
//
//  Created by naga on 2/18/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
import Alamofire
import Parse

class BCAPIManager: NSObject {
    static let shared = BCAPIManager()
    
    private func trigger(email: String, completion: @escaping (Int?, Error?) -> Void) {
        let headers = [
            "X-Parse-Application-Id" : ParseApplicationId,
            "X-Parse-REST-API-Key" : ParseRestAPIKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let params = [
            "email" : email,
            "installation_id" : PFInstallation.current()!.objectId!
        ] as [String : Any]
        
        Alamofire.request(ParseServerURL + "functions/trigger", method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
            
            self.getBreachesForEmail(email: email, is_read: nil, completion: { (breaches, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(breaches?.count, nil)
                }
            })
        }
    }
    
    private func deleteBreachesByEmail(email: BCEmailModel, completion: @escaping (Bool, Error?) -> Void ) {
        let query = PFQuery(className: "Breach")
        query.whereKey("email", equalTo: email)
        query.whereKey("device", equalTo: PFInstallation.current()!)
        query.findObjectsInBackground { (objects, error) in
            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    object.deleteInBackground(block: { (success, error) in
                        if let error = error {
                            completion(false, error)
                            return
                        }
                        
                        if index == objects.count - 1 {
                            completion(true, nil)
                        }
                    })
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    func getAllEmails(completion: @escaping ([String]?, Error?) -> Void) {
        let query = PFQuery(className: "Email")
        query.whereKey("device", equalTo: PFInstallation.current()!)
        query.findObjectsInBackground { (objects, error) in
            if let objects = objects {
                var ret: [String] = []
                for object in objects {
                    if let email = object["email"] as? String {
                        ret.append(email)
                    }
                }
                
                completion(ret, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func addEmail(email: String, completion: @escaping (Int?, Error?) -> Void) {
        let obj = BCEmailModel()
        obj.email = email
        obj.device = PFInstallation.current()
        obj.saveInBackground { (success, error) in
            if let error = error {
                completion(nil, error)
            } else {
                self.trigger(email: email, completion: { (count, error) in
                    completion(count, error)
                })
            }
        }
    }
    
    func updateEmail(oldEmail: String, newEmail: String, completion: @escaping (Int?, Error?) -> Void) {
        self.deleteEmail(email: oldEmail) { (success, error) in
            if let error = error {
                completion(nil, error)
            } else {
                self.addEmail(email: newEmail, completion: { (count, error) in
                    completion(count, error)
                })
            }
        }
    }
    
    func deleteEmail(email: String, completion: @escaping (Bool, Error?) -> Void) {
        let query = PFQuery(className: "Email")
        query.whereKey("email", equalTo: email)
        query.whereKey("device", equalTo: PFInstallation.current()!)
        query.getFirstObjectInBackground { (obj, error) in
            if let obj = obj {
                obj.deleteInBackground(block: { (success, error) in
                    if let error = error {
                        completion(false, error)
                    } else if let obj_email = obj as? BCEmailModel {
                        self.deleteBreachesByEmail(email: obj_email, completion: { (success, error) in
                            completion(success, error)
                        })
                    }
                })
            } else {
                completion(false, error)
            }
        }
    }
    
    func getBreachesForEmail(email: String, is_read: Bool?, completion: @escaping ([BCBreachModel]?, Error?) -> Void) {
        let query = PFQuery(className: "Email")
        query.whereKey("email", equalTo: email)
        query.whereKey("device", equalTo: PFInstallation.current()!)
        query.getFirstObjectInBackground { (obj, error) in
            if let obj = obj {
                let query = PFQuery(className: "Breach")
                query.whereKey("device", equalTo: PFInstallation.current()!)
                query.whereKey("email", equalTo: obj)
                
                if let is_read = is_read {
                    query.whereKey("is_read", equalTo: is_read)
                }
                query.limit = 1000
                query.addDescendingOrder("breach_date")
                
                query.findObjectsInBackground(block: { (objects, error) in
                    if let objects = objects {
                        var ret: [BCBreachModel] = []
                        for object in objects {
                            if let breach = object as? BCBreachModel {
                                ret.append(breach)
                            }
                        }
                        completion(ret, nil)
                    } else {
                        completion(nil, error)
                    }
                })
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getAllBreaches(is_read: Bool?, completion: @escaping ([BCBreachModel]?, Error?) -> Void) {
        let query = PFQuery(className: "Breach")
        query.whereKey("device", equalTo: PFInstallation.current()!)
        query.includeKey("email")
        
        if let is_read = is_read {
            query.whereKey("is_read", equalTo: is_read)
        }
        query.limit = 1000
        query.addDescendingOrder("breach_date")
        
        query.findObjectsInBackground(block: { (objects, error) in
            if let objects = objects {
                var ret: [BCBreachModel] = []
                for object in objects {
                    if let breach = object as? BCBreachModel {
                        ret.append(breach)
                    }
                }
                completion(ret, nil)
            } else {
                completion(nil, error)
            }
        })
    }
}
