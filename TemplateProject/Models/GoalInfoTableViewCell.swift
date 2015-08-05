//
//  GoalInfoTableViewCell.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 8/4/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class GoalInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
