//
//  ParseHelper.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class ParseHelper {
   
    // User Relation
    static let ParseUserUsername      = "username"
    static let ParseUserClass      = "User"
    static let ParseFriendsArray = "friends"
    
    // Friend Relation
    static let ParseFollowClass       = "Friend"
    static let ParseAcceptedFriend    = "Accepted"
    static let ParseFollowFromUser    = "fromUser"
    static let ParseFollowToUser      = "toUser"
    
    //Like Relation
    static let ParseLikeClass         = "Like"
    static let ParseLikeToPost        = "toGoal"
    static let ParseLikeFromUser      = "fromUser"
    
    //Flag Relation
    static let ParseFlagClass         = "Flag"
    static let ParseFlagToPost        = "toGoal"
    static let ParseFlagFromUser      = "fromUser"
    static let ParseFlageMessage      = "message"

    
    //MARK: Users
    //fetches all the users, except the ones that are currently logined in
    //also limits the amount of users returned to 20
    static func allUsers(completionBlock: PFArrayResultBlock) -> PFQuery{
        let query = PFUser.query()!
        query.whereKey(ParseUserUsername, notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(ParseUserUsername)
        query.limit = 20 //only returns 20 users
        query.findObjectsInBackgroundWithBlock(completionBlock)
        return query
    }
    static func accomplishments(user: PFUser, completionBlock: PFArrayResultBlock) {
        
        let postsFromThisUser = Goal.query()
        postsFromThisUser!.whereKey("ofUser", equalTo: user)
        postsFromThisUser!.whereKey("accomplished", equalTo: true)
        postsFromThisUser!.whereKey("shareable", equalTo: true)
        
        postsFromThisUser!.includeKey("ofUser")
        
        postsFromThisUser!.orderByDescending("createdAt")
        
        
        postsFromThisUser!.findObjectsInBackgroundWithBlock(completionBlock)
    }
    //fetch users whose usernames match the provided search term
    static func searchUsers(searchText: String, completionBlock: PFArrayResultBlock) -> PFQuery {
        
        //here we are using regex to allow for case insensitive comparison
        //but usually, don't use regex because it can be quite slow for large datasets, instead just set another collum in parse that has the usernames in lowercase
        let query = PFUser.query()!.whereKey(ParseUserUsername, matchesRegex: searchText, modifiers: "i")
        
        query.whereKey(ParseUserUsername, notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(ParseUserUsername)
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completionBlock)
        return query
    }
    //MARK: IMAGES

    static func getImages(goal: Goal, completionBlock: PFArrayResultBlock) {
        let goalQuery = Goal.query()
        goalQuery?.whereKey("objectId", equalTo: goal.objectId!)
        goalQuery?.findObjectsInBackgroundWithBlock(completionBlock)
        
        
    }
    static func getFriendsForUser(user:PFUser, completionBlock: PFArrayResultBlock ){
        
        let query = PFQuery(className: "Friend")
        query.whereKey(ParseFollowFromUser, equalTo: user)
        //query.includeKey(ParseFriendsArray)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    //MARK: FRIENDS)
    static func addFriendRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let friendObject = PFObject(className: ParseFollowClass)
        friendObject.setObject(user, forKey: ParseFollowFromUser)
        friendObject.setObject(toUser, forKey: ParseFollowToUser)
        friendObject.saveInBackgroundWithBlock(nil)
    }
    
    static func removeFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
        
        let query = PFQuery(className: ParseFollowClass)
        query.whereKey(ParseFollowFromUser, equalTo: user)
        query.whereKey(ParseFollowToUser, equalTo: toUser)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            let results = results as? [PFObject] ?? []
            
            for follow in results {
                follow.deleteInBackgroundWithBlock(nil)
            }
        }
        
    }
    static func checkForFriendRequests() {
        let query = PFQuery(className: ParseFollowClass)
        query.whereKey(ParseFollowFromUser, equalTo: PFUser.currentUser()!)
        query.whereKey(ParseAcceptedFriend, equalTo: false)
        query.findObjectsInBackground()

    }

    
    static func getProfileImage(user: PFUser) {
        
        let userPhoto = PFObject(className: "User")
        let userImageFile = userPhoto["profileImage"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if !(error != nil) {
                let image = UIImage(data:imageData!)
                println(image)
            }
        }
        
    }
    static func allPostsWithRating(starRating: Int, completionBlock: PFArrayResultBlock) {
        let postsForUser = Goal.query()
        postsForUser?.whereKey("ofUser", equalTo: PFUser.currentUser()!)
        postsForUser?.whereKey("starRating", equalTo: starRating)
        postsForUser?.limit = 20
        postsForUser?.findObjectsInBackgroundWithBlock(completionBlock)
        

    }
    static func timelineRequestforCurrentUser(completionBlock: PFArrayResultBlock) {
        
        let followingQuery = PFQuery(className: "Friend")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        let postsFromFollowedUsers = Goal.query()
        postsFromFollowedUsers!.whereKey("ofUser", matchesKey: "toUser", inQuery: followingQuery)
        postsFromFollowedUsers!.whereKey("accomplished", equalTo: true)
        postsFromFollowedUsers!.whereKey("shareable", equalTo: true)
        
        let postsFromThisUser = Goal.query()
        postsFromThisUser!.whereKey("ofUser", equalTo: PFUser.currentUser()!)
        postsFromThisUser!.whereKey("accomplished", equalTo: true)
        postsFromThisUser!.whereKey("shareable", equalTo: true)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        
        query.includeKey("ofUser")
    
        query.orderByDescending("createdAt")
 
        
        query.findObjectsInBackgroundWithBlock(completionBlock)

    }
    static func likesForPost(goal: Goal, completionBlock: PFArrayResultBlock) {
        let fetchLikes = PFQuery(className: ParseLikeClass)
        fetchLikes.whereKey(ParseLikeToPost, equalTo: goal)
        fetchLikes.includeKey(ParseLikeFromUser)
        
        fetchLikes.findObjectsInBackgroundWithBlock(completionBlock)
    }
    static func addLike(goal:Goal) {
        
        let currentLikes = PFObject(className: ParseLikeClass )
        currentLikes[ParseLikeFromUser] = PFUser.currentUser()
        currentLikes[ParseLikeToPost] = goal
        currentLikes.saveInBackground()
    }
    static func removeLike(goal: Goal) {
        let currentLikes = PFQuery(className: ParseLikeClass)
        currentLikes.whereKey(ParseLikeToPost, equalTo: goal)
        currentLikes.whereKey(ParseLikeFromUser, equalTo: PFUser.currentUser()!)
        
        currentLikes.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            if let results = results as? [PFObject] {
                for likes in results {
                    likes.deleteInBackgroundWithBlock(nil)
                }
                
            }
            
        }
    }
    
    static func isAFriend(user1:PFUser, user2: PFUser, completionBlock: PFArrayResultBlock) {
        let friendQuery = PFQuery(className: ParseFollowClass)
        friendQuery.whereKey(ParseFollowFromUser, equalTo: user1)
        friendQuery.whereKey(ParseFollowToUser, equalTo: user2)
        friendQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    static func addFlag(goal: Goal, user: PFUser, message: String) {
        
        let flagObject = PFObject(className: ParseFlagClass)
        flagObject.setObject(user, forKey: ParseFlagFromUser)
        flagObject.setObject(goal, forKey: ParseFlagToPost)
        flagObject.setObject(message, forKey: ParseFlageMessage)
        flagObject.saveInBackgroundWithBlock(nil)
    }
    
}

extension PFObject : Equatable {
    
}

public func ==(lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}
