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
    //var currentRow = -1
    var likes: Int = 0
    var dictionaryOfLikes = [Int: [PFUser]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.timelineRequestforCurrentUser {
            (result: [AnyObject]?, error: NSError?) -> Void in
            self.goals = result as? [Goal] ?? []
            
            for eachgoal in self.goals {
                
                let data = eachgoal.imageFile?.getData()
                
                if (data != nil) {
                    eachgoal.image = UIImage(data: data!, scale:1.0)
                }
                
                let user = eachgoal.ofUser
                self.users.append(user!)
            }
            self.tableView.reloadData()
        }
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
        cell.commentButton.selectCom = indexPath.row
        cell.likesLabel.text = "\(numOfLikes.count)"
        cell.likesArray = numOfLikes
        cell.viewLikesButton.selectCom = indexPath.row
        dictionaryOfLikes[indexPath.row] = numOfLikes
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


