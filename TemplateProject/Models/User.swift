//
//  User.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/28/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//


import UIKit
import Parse
import Bond

class User: PFUser, PFSubclassing{
    
    //@NSManaged var username: String?
    //@NSManaged var password: String?
    @NSManaged var quote: String?
    @NSManaged var profileImage: PFFile?
    @NSManaged var visionboardImage: PFFile?
    
    var image: Dynamic<UIImage?> = Dynamic(nil)

    
    
   // static func parseClassName() -> String {
     //   return "User"
    //}
    
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
    func downloadImage() { //understand
        
        if(image.value == nil) {
            
            //get the data of the imageFile on a seperate thread, so its not going on the main thread
            profileImage?.getDataInBackgroundWithBlock{ (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale: 1.0)
                    self.image.value = image // once the image is recieved, we store it in the image property of the post.
                    println("DONE \(self.image.value)")
                }
            }
        }
        
    }
}

