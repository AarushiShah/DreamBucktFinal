//
//  CommentTableViewCell.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

