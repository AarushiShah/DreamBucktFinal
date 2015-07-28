//
//  FriendsCell.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/21/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class FriendsCell: UICollectionViewCell {
    
    var friend: Bool = false
    
    @IBOutlet var imgCell: UIImageView!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet var lblCell: UILabel!
    
    var user: PFUser? {
        didSet {
            lblCell.text = user?.username
        }
    }
    
    @IBAction func friendButtonTapped(sender: AnyObject) {
            
            if friend {
                friendButton.setImage(UIImage(named:"Friend Add"), forState: .Normal)
                friend = false
                
            }
            else {
                friendButton.setImage(UIImage(named:"Friend"), forState: .Normal)
                ParseHelper.addFriendRelationshipFromUser(PFUser.currentUser()!, toUser: user!)
                ParseHelper.addFriendRelationshipFromUser(user!, toUser: PFUser.currentUser()!)
                friend = true
        }
    }
}
