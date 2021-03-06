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
import Mixpanel

class ProfileViewController: UIViewController,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {

    @IBOutlet weak var visionboardButton: UIButton!
    @IBOutlet weak var visionboardImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendsButton: UIButton! //button to display number of friends user has
    @IBOutlet weak var bucketButton: UIButton!
    @IBOutlet weak var friendButton: UIButton! //buton to add/delete friend
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var quoteTextField: UITextField!
    
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
    var editClicked: Int = 0
    
    
    override func viewDidLoad() {
        
         quoteTextField.hidden = true
    Mixpanel.sharedInstanceWithToken("46ebc5702d4346b9a6b91b32153cd1bc")
       let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Profile Viewed")
        
        tableView.hidden = true
        usernameLabel.text = user.username
        quoteLabel.text = user["quote"] as? String
        visionboardImage.hidden = true
        
        profileImageView.image = profileImage
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        
        if user != PFUser.currentUser() {
            logoutButton.hidden = true
            editButton.hidden = true

        } else {
            let tapRec = UITapGestureRecognizer()
            tapRec.addTarget(self, action: "tappedView:")
            profileImageView.addGestureRecognizer(tapRec)
            profileImageView.userInteractionEnabled = true
            friendButton.hidden = true
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
        
        var existingUser = user
        if let userImageFile = existingUser!["visionboardImage"] as? PFFile {
            
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                
                let image = UIImage(data:imageData!)
               // print(existingUser)
               // existingUser.fetch()
                  print(existingUser)
                println(existingUser!["share"] as? Bool)
                if existingUser!["share"] as? Bool == true || existingUser!["share"] as? Bool == nil  {
                      self.visionboardImage.image = image
                } else {
                    self.visionboardButton.hidden = true

                }
                
            }
        } else {
            visionboardButton.hidden = true
        }

        
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        editClicked++
        
        if editClicked % 2 == 0 {
            editButton.setTitle("EDIT", forState: .Normal)
            quoteTextField.hidden = true
            quoteLabel.text = quoteTextField.text
            ParseHelper.saveMotivationalQuote(quoteTextField.text)
            
        } else {
            editButton.setTitle("SAVE", forState: .Normal)
            quoteTextField.hidden = false
            if quoteLabel.text != "" {
                quoteTextField.text = quoteLabel.text
            }
            
            
        }
    }
    
  
    @IBAction func viewFriendsButtonTapped(sender: AnyObject) {
        tableView.hidden = false
        visionboardImage.hidden = true
        whichOne = "friends"
        tableView.reloadData()
    }
    @IBAction func viewVisionboardTapped(sender: AnyObject) {
         tableView.hidden = true
         visionboardImage.hidden = false
        

            
    }
    @IBAction func viewAccomplishments(sender: AnyObject) {
        tableView.hidden = false
         visionboardImage.hidden = true
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if PFUser.currentUser() == user {
            ParseHelper.updateImage(profileImageView.image!)
            
            if editClicked % 2 != 0 {
                ParseHelper.saveMotivationalQuote(quoteTextField.text)
            }
            
        }
    }
    @IBAction func logoutAction(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .Default) { action -> Void in
            PFUser.logOut()
            self.loginSetup()
        }
         alertController.addAction(logoutAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func loginSetup() {
        
        if (PFUser.currentUser() == nil) {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
             appDelegate.presentLogout()
//            
//            var logInViewController = PFLogInViewController()
//            
//            logInViewController.delegate = self
//            
//            var signUpViewController = PFSignUpViewController()
//            
//            signUpViewController.delegate = self
//            
//            logInViewController.signUpController = signUpViewController
//            
//            self.presentViewController(logInViewController, animated: true, completion: nil)
//            
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