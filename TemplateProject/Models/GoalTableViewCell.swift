//
//  GoalTableViewCell.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import Bond

class GoalTableViewCell: UITableViewCell {
    
    var likedByUser = false
    var numOfLikes: Int = 0
    var likeBond: Bond<[PFUser]?>!

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
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        goal?.toggleLikePost(PFUser.currentUser()!)
    }

}
