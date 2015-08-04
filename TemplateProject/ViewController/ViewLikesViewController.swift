//
//  ViewLikesViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 8/3/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class ViewLikesViewController: UIViewController {

    
    var likes: [PFUser] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        println(likes.count)
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}


extension ViewLikesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LikesCell") as! ViewLIkesTableViewCell
        
        likes[indexPath.row].fetchIfNeeded()
        
        cell.usernameLabel.text = likes[indexPath.row].username
        
        var image: AnyObject? = likes[indexPath.row]["profileImage"]
        if (image != nil) {
            let data = image!.getData()
            
            if (data != nil) {
                var profileImage = UIImage(data: data!, scale:1.0)
                cell.profileImage.image = profileImage
            }
            
        }

        
        
        return cell
    }
}

