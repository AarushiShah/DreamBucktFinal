//
//  GoalTableViewCell.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Foundation
import Parse
import Bond

class GoalTableViewCell: UITableViewCell {
    
    var likedByUser = false
    var inputTextField: UITextField?
    var numOfLikes: Int = 0
    var likesArray: [PFUser] = []
    var likeBond: Bond<[PFUser]?>!
    var viewController: TimelineViewController?

    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var accomplishedTitle: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var commentButton: CommentButton!
    
    var goal:Goal? {
        didSet {
            if let goal = goal {
                // bind the likeBond that we defined earlier, to update like label and button when likes change
                goal.likes ->> likeBond
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                // 1
        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
            // 2
            if let likeList = likeList {

                self.likesLabel.text = MethodHelper.stringFromUserList(likeList)
                self.likeButton.selected = contains(likeList, PFUser.currentUser()!)

            } else {
                self.likesLabel.text = "0"
                self.likeButton.selected = false
            }
        }
    }
    @IBAction func viewLikesButtonTapped(sender: AnyObject) {
         //performSegueWithIdentifier("viewLikes", sender: nil)
    }
    @IBAction func moreButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let flagContentAction = UIAlertAction(title: "Flag Post", style: .Default) { (action) in
                    self.addFlagAlertView()
        }
        alertController.addAction(flagContentAction)
        viewController!.presentViewController(alertController, animated: true, completion: nil)

        
    }
    
    func addFlagAlertView() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Flag Content", message: "Why are you reporting this post?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheetController.addAction(cancelAction)
        
        let done = UIAlertAction(title: "Done", style: .Default) { (action) in
               ParseHelper.addFlag(self.goal!, user: PFUser.currentUser()!, message: self.inputTextField!.text)
        }
        
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.textColor = UIColor.blueColor()
            self.inputTextField = textField
            
        }
        
        
        actionSheetController.addAction(done)
        self.viewController!.presentViewController(actionSheetController, animated: true, completion: nil)
        

    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        goal?.toggleLikePost(PFUser.currentUser()!)
    }

}
