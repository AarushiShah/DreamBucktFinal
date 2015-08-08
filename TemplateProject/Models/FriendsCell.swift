//
//  FriendsCell.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/21/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import Mixpanel

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
                ParseHelper.removeFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user!)
                ParseHelper.removeFollowRelationshipFromUser(user!, toUser: PFUser.currentUser()!)
                friend = false
                
            }
            else {
                friendButton.setImage(UIImage(named:"Friend"), forState: .Normal)
                ParseHelper.addFriendRelationshipFromUser(PFUser.currentUser()!, toUser: user!)
                ParseHelper.addFriendRelationshipFromUser(user!, toUser: PFUser.currentUser()!)
                friend = true
                
                Mixpanel.sharedInstanceWithToken("46ebc5702d4346b9a6b91b32153cd1bc")
                let mixpanel: Mixpanel = Mixpanel.sharedInstance()
                mixpanel.track("Friend Added")
        }
    }
}
