//
//  GoalTableViewCell.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {
    
    var likedByUser = false

    @IBOutlet weak var goalImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        if likedByUser {
            likeButton.setImage(UIImage(named:"Heart"), forState: .Normal)
            likedByUser = false
            
        }
        else {
            likeButton.setImage(UIImage(named:"Heart Selected"), forState: .Normal)
            likedByUser = true
        }
        

        
    }
}
