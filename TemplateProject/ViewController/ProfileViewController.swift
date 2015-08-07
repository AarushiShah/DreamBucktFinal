//
//  ProfileViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/23/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import ParseUI
//import Mixpanel

class ProfileViewController: UIViewController,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendsButton: UIButton! //button to display number of friends user has
    @IBOutlet weak var bucketButton: UIButton!
    @IBOutlet weak var friendButton: UIButton! //buton to add/delete friend
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var photoTakingHelper:PhotoTakingHelper?
    var user: PFUser!
    var numberOfFriends:Int?
    var friend: Bool = false
    var profileImage: UIImage?
    var friendsArray = [AnyObject]()
    var goalsArray = [Goal]()
    var whichOne: String = "friends"
    var selecteduser: PFUser!
    var selectedimage:UIImage!
    var profileImages = [UIImage]()
    var userArray = [PFUser]()
    
    
    override func viewDidLoad() {
        
       // let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        //mixpanel.track("Profile Viewed", properties: ["User":user!])
        
        tableView.hidden = true
        usernameLabel.text = user.username
        quoteLabel.text = user["quote"] as? String
        
        profileImageView.image = profileImage
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        
        if user != PFUser.currentUser() {
            logoutButton.hidden = true

        } else {
            let tapRec = UITapGestureRecognizer()
            tapRec.addTarget(self, action: "tappedView:")
            profileImageView.addGestureRecognizer(tapRec)
            profileImageView.userInteractionEnabled = true
        }
        
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
        
        ParseHelper.accomplishments(user) {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            self.goalsArray = results as? [Goal] ?? []
            
            self.bucketButton.setTitle("   \(self.goalsArray.count)", forState: .Normal)

        }

        
    }
  
    @IBAction func viewFriendsButtonTapped(sender: AnyObject) {
        tableView.hidden = false
        whichOne = "friends"
        tableView.reloadData()
    }
    
    @IBAction func viewAccomplishments(sender: AnyObject) {
        tableView.hidden = false
        whichOne = "accomplish"
        tableView.reloadData()
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
    func tappedView(sender:UITapGestureRecognizer) {
        photoTakingHelper = PhotoTakingHelper(viewController: self) { (image: UIImage?) in
            
            self.profileImageView.image = image
        }
        
    }
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        
    }
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
        
        self.loginSetup()
    }
    
    func loginSetup() {
        
        if (PFUser.currentUser() == nil) {
            
            var logInViewController = PFLogInViewController()
            
            logInViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            
            signUpViewController.delegate = self
            
            logInViewController.signUpController = signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
            
           }
        }
}



extension ProfileViewController: UITableViewDataSource {
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
          if whichOne == "friends"{
                if (numberOfFriends != nil) {
                    return numberOfFriends!

                } else {
                    return 0
                }
          } else {
            if (goalsArray.count != 0) {
                return goalsArray.count
                
            } else {
                return 0
            }
          }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      if whichOne == "friends" {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell") as! UsersFriendsTableViewCell
        
        friendsArray[indexPath.item].fetchIfNeeded()
        cell.usernameLabel.text = friendsArray[indexPath.item].username
        userArray.append(friendsArray[indexPath.item] as! PFUser)
        
        var image: AnyObject? = friendsArray[indexPath.item]["profileImage"]
        if (image != nil) {
            let data = image!.getData()
            
            if (data != nil) {
                var profileImage = UIImage(data: data!, scale:1.0)
                profileImages.append(profileImage!)
                cell.profileImage.image = profileImage
            } else {
                profileImages.append(UIImage(named: "photo1.png")!)
            }
            
        } else {
            profileImages.append(UIImage(named: "photo1.png")!)
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
      } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("GoalCell") as! GoalInfoTableViewCell
        
            cell.goalTitle.text = goalsArray[indexPath.row].title
        
            let data = goalsArray[indexPath.row].imageFile!.getData()
            
            if (data != nil) {
                cell.imageView?.image = UIImage(data: data!, scale:1.0)
            }
    
            return cell
        }
    }
}