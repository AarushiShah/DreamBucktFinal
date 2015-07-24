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
    static func getFriendsForUser(user:PFUser, completionBlock: PFArrayResultBlock ) {
        
        let query = PFUser.query()!
        query.whereKey(ParseUserUsername, equalTo: PFUser.currentUser()!.username!)
        query.includeKey(ParseFriendsArray)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }

}

