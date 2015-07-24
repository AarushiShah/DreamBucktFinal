//
//  Goal.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class Goal: PFObject, PFSubclassing{
    
    @NSManaged var title: String?
    @NSManaged var goalDescription: String?
    @NSManaged var externalLink: String?
    @NSManaged var starRating: Int
    @NSManaged var dateGoal: NSDate?
    @NSManaged var shareable: Bool
    @NSManaged var ofUser: PFUser?
    
   
    static func parseClassName() -> String {
        return "Goal"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func uploadGoal () {
        ofUser = PFUser.currentUser()
        saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            println("save succesfully")
        }
        

    }
}
