//
//  Comment.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Foundation
import Bond
import Parse
import ConvenienceKit

class Comment: PFObject, PFSubclassing  {
    @NSManaged var commentString: String?
    @NSManaged var date: NSDate?
    @NSManaged var fromUser: PFUser?
    @NSManaged var toGoal: PFObject?
    
    static func parseClassName() -> String {
        return "Comment"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func uploadReply() {
        //post = PFObject.currentPost()
        fromUser = PFUser.currentUser()
        
        saveInBackgroundWithBlock(nil)
        
    }
}

    