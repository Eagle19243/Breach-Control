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
    
    func trigger(email: String) {
        let headers = [
            "X-Parse-Application-Id" : ParseApplicationId,
            "X-Parse-REST-API-Key" : ParseRestAPIKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "email" : email
        ]
        
        Alamofire.request(ParseServerURL + "functions/trigger", method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    if let json = response.result.value {
                        print(json)
                    }
                    print("Succeed in API request")
                case .failure:
                    print("Failed in API request")
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
    
    func addEmail(email: String, completion: @escaping (Bool, Error?) -> Void) {
        let obj = BCEmailModel()
        obj.email = email
        obj.device = PFInstallation.current()
        obj.saveInBackground { (success, error) in
            completion(success, error)
        }
    }
    
    func updateEmail(oldEmail: String, newEmail: String, completion: @escaping (Bool, Error?) -> Void) {
        let query = PFQuery(className: "Email")
        query.whereKey("email", equalTo: oldEmail)
        query.whereKey("device", equalTo: PFInstallation.current()!)
        query.getFirstObjectInBackground { (obj, error) in
            if let obj = obj as? BCEmailModel {
                obj.email = newEmail
                obj.saveInBackground(block: { (success, error) in
                    completion(success, error)
                })
            } else {
                completion(false, error)
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
                    completion(success, error)
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
}
