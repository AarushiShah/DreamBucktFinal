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

    
    var user: PFUser!
    
    override func viewDidLoad() {
        println(user)
        println(user["quote"])
        //user.downloadImage()
        
    }
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        
    }
    
}
