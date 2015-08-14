//
//  HelpViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 8/13/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class HelpViewController: UIViewController {

    @IBOutlet weak var shareableSwitch: UISwitch!
    var shareWithFriends: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

       var user = PFUser.currentUser()
        if user!["share"] as? Bool == true || user!["share"] as? Bool == nil {
            shareableSwitch.on = true
            shareWithFriends = true
        } else {
            shareableSwitch.on = false
            shareWithFriends = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareableSwitched(sender: AnyObject) {
        
        if shareableSwitch.on {
                shareWithFriends = true
            }
            else {
                shareWithFriends = false
            }
            
        
    }
    @IBAction func doneButtonClicked(sender: AnyObject) {
        var newUser = PFUser.currentUser()
        newUser!.setObject(shareWithFriends, forKey: "share")
        newUser!.saveInBackground()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
