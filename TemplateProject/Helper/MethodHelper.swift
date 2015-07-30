//
//  MethodHelper.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/30/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//


import Parse

class MethodHelper {

    static func stringFromUserList(userList: [PFUser]) -> String {
        
        let usernameList = userList.map { user in user.username! }
        
        return "\(usernameList.count)"
    }
}
