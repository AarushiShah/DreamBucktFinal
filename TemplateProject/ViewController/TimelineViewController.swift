//
//  TimelineViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController,Likes {
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var viewLikesButton: CommentButton!

    var goals: [Goal] = []
    var users: [PFUser] = []
    var numOfLikes: [PFUser] = []
    var cellTapped:Bool = true
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var likes: Int = 0
    var dictionaryOfLikes = [Int: [PFUser]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        ParseHelper.timelineRequestforCurrentUser {
            (result: [AnyObject]?, error: NSError?) -> Void in
            self.goals = result as? [Goal] ?? []
            
            if self.goals.count == 0 {
                let alertController = UIAlertController(title: nil, message: "No Posts for Timeline", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let addGoalAction = UIAlertAction(title: "Add Friends", style: .Default) { (action) in
                   // let tabbar = UITabBarw()//if declare and initilize like this
                    
                   // tabbar.selectedItem = tabbar.items![3] as? UITabBarItem
                    //self.performSegueWithIdentifier("friends", sender: self)
                }
                alertController.addAction(addGoalAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)

            }
            
            for eachgoal in self.goals {
                
                let data = eachgoal.imageFile?.getData()
                
                if (data != nil) {
                    eachgoal.image = UIImage(data: data!, scale:1.0)
                }
                
                let user = eachgoal.ofUser
                self.users.append(user!)
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
            }
    func numLikes(number: Int) {
        likes = number
        performSegueWithIdentifier("viewLikes", sender: self)
        
        
    }
    @IBAction func commentButtonTapped(sender: AnyObject) {
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewLikes" {
            var likesVC: ViewLikesViewController = segue.destinationViewController as! ViewLikesViewController
            println(dictionaryOfLikes[likes]!)
            likesVC.likes = dictionaryOfLikes[likes]!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return goals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GoalCell") as! GoalTableViewCell
        
        cell.goalImageView.image = goals[indexPath.row].image
        cell.titleLable?.text = goals[indexPath.row].title
        let username = users[indexPath.row].username
        cell.accomplishedTitle.text = ("\(username!) Accomplished a Goal")
        cell.floatRatingView.emptyImage = UIImage(named: "Star")
        cell.floatRatingView.fullImage = UIImage(named: "SelectedStar")
        cell.floatRatingView.editable = false
        cell.floatRatingView.rating = goals[indexPath.row].starRating
        cell.goal = goals[indexPath.row]
        numOfLikes = goals[indexPath.row].fetchLikes()
        println("\(numOfLikes) \(indexPath.row)")
        cell.likesLabel.text = "\(numOfLikes.count)"
        cell.likesArray = numOfLikes
        cell.commentButton.selectCom = indexPath.row
        cell.viewLikesButton.selectCom = indexPath.row
        dictionaryOfLikes[indexPath.row] = numOfLikes
        println("num of likes \(numOfLikes.count)")
        cell.viewController = self
        
        
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("GoalCell") as! GoalTableViewCell
//        
//        if indexPath.row == currentRow {
//            if cellTapped == false {
//                cellTapped = true
//                return 141
//            } else {
//                cellTapped = false
//                return 70
//            }
//        }
//        return 70
//    }
        return 320
    }
}


