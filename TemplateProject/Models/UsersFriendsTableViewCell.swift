//
//  UsersFriendsTableViewCell.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 8/2/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class UsersFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
