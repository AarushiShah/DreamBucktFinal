//
//  ProfileViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/23/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendsButton: UIButton! //button to display number of friends user has
    @IBOutlet weak var bucketButton: UIButton!
    @IBOutlet weak var friendButton: UIButton! //buton to add/delete friend
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var user: PFUser!
    var numberOfFriends:Int?
    var friend: Bool = false
    var profileImage: UIImage?
    var friendsArray = [AnyObject]()
    
    
    override func viewDidLoad() {
        
        tableView.hidden = true
        usernameLabel.text = user.username
        quoteLabel.text = user["quote"] as? String
        
        profileImageView.image = profileImage
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        
        ParseHelper.getFriendsForUser(user) {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            self.numberOfFriends = results?.count
            if let reslts = results {
                for eachfriend in reslts {
                    if (eachfriend["toUser"] != nil) {
                        self.friendsArray.append(eachfriend["toUser"]!! as! PFUser)
                    }
                }
            }
            self.friendsButton.setTitle("   \(self.numberOfFriends!)", forState: .Normal)
            self.tableView.reloadData()
            
        }
        
        ParseHelper.isAFriend(user, user2: PFUser.currentUser()!) {
            
            (results: [AnyObject]?,error: NSError?) -> Void in
            if (results?.count != 0) {
                self.friendButton.setImage(UIImage(named:"Friend"), forState: .Normal)
                self.friend = true
            } else {
                self.friendButton.setImage(UIImage(named:"Friend Add"), forState: .Normal)
                self.friend = false
            }
        }

        
    }
  
    @IBAction func viewFriendsButtonTapped(sender: AnyObject) {
        tableView.hidden = false
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
        }

        
    }
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        
    }
}



extension ProfileViewController: UITableViewDataSource {
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (numberOfFriends != nil) {
            return numberOfFriends!

        } else {
            return 0
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as! UsersFriendsTableViewCell
        
        friendsArray[indexPath.item].fetchIfNeeded()
        cell.usernameLabel.text = friendsArray[indexPath.item].username
        
        var image: AnyObject? = friendsArray[indexPath.item]["profileImage"]
        if (image != nil) {
            let data = image!.getData()
            
            if (data != nil) {
                var profileImage = UIImage(data: data!, scale:1.0)
                cell.profileImage.image = profileImage
            }
            
        }
        
        ParseHelper.isAFriend(friendsArray[indexPath.item] as! PFUser, user2: PFUser.currentUser()!) {
            
            (results: [AnyObject]?,error: NSError?) -> Void in
            if (results?.count != 0) {
                cell.addFriendButton.setImage(UIImage(named:"Friend"), forState: .Normal)
                //self.friend = true
            } else {
                 cell.addFriendButton.setImage(UIImage(named:"Friend Add"), forState: .Normal)
                //self.friend = false
            }
        }


        return cell
    }
}