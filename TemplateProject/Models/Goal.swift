//
//  Goal.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import Bond

class Goal: PFObject, PFSubclassing{
    
    @NSManaged var title: String?
    @NSManaged var goalDescription: String?
    @NSManaged var externalLink: String?
    @NSManaged var starRating: Float
    @NSManaged var dateGoal: NSDate?
    @NSManaged var shareable: Bool
    @NSManaged var accomplished: Bool
    @NSManaged var ofUser: PFUser?
    @NSManaged var imageFile: PFFile?
    @NSManaged var imageFileArray: [PFFile]?
    
    var image:UIImage?
    var likes =  Dynamic<[PFUser]?>(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    var photoUploadTask2: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var eachimage: PFFile?

    
   
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
        
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        imageFile = PFFile(data:imageData)
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler{ () -> Void in
            
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        imageFile!.saveInBackgroundWithBlock { (succes: Bool, error: NSError?) -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        

        ofUser = PFUser.currentUser()
        saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            println("save succesfully")
        }
    }

    func updateAccomplish(completed: Bool) {
        self.accomplished = completed
        println(accomplished)
        self.saveInBackground()
    }
    func updateShareable(share: Bool) {
        self.shareable = share
        self.saveInBackground()
    }
    
    func updateImages(image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        imageFile = PFFile(data:imageData)
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler{ () -> Void in
            
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        imageFile!.saveInBackgroundWithBlock { (succes: Bool, error: NSError?) -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        self.saveInBackground()

//        for each in images {
//            let imageData = UIImageJPEGRepresentation(each, 0.8)
//          if imageData != nil {
//            eachimage = PFFile(data:imageData)
//            imageFileArray?.append(eachimage!)
//            photoUploadTask2 = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler{ () -> Void in
//                
//                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask2)
//            }
//            
//            eachimage!.saveInBackgroundWithBlock { (succes: Bool, error: NSError?) -> Void in
//                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask2)
//            }
//          }
//        }
//        self.saveInBackground()

    }

    func doesUserLikePost(user: PFUser) -> Bool {
        if let likes = likes.value {
            return contains(likes, user)
        } else {
            return false
        }
    }
    
    func toggleLikePost(user: PFUser) {
        if (doesUserLikePost(user)) {
            likes.value = likes.value?.filter { $0 != user }
            ParseHelper.removeLike(self)
        } else {
            likes.value?.append(user)
            ParseHelper.addLike(self)
        }
    }
    
    func fetchLikes() -> [PFUser] {
        
        if (likes.value == nil) {
        ParseHelper.likesForPost(self, completionBlock: { (var likes: [AnyObject]?, error: NSError?) -> Void in
            likes = likes?.filter { like in like[ParseHelper.ParseLikeFromUser] != nil }
            
            self.likes.value = likes?.map { like in
                let like = like as! PFObject
                let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser

                return fromUser
                
            }
            
            
         })
        }
        
        if let numLikes = self.likes.value{
            return numLikes
        }
        else {
            return []
        }
    }
}
