//
//  TimelineViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.timelineRequestforCurrentUser {
            (result: [AnyObject]?, error: NSError?) -> Void in
            self.goals = result as? [Goal] ?? []
            
            for eachgoal in self.goals {
                // 2
                let data = eachgoal.imageFile?.getData()
                // 3
                if (data != nil) {
                    eachgoal.image = UIImage(data: data!, scale:1.0)
                }
            }
            self.tableView.reloadData()
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
        // 2
        
        if (goals[indexPath.row].image == nil) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("PendingGoalCell") as! PendingGoalTableViewCell
            cell.textLabel?.text = goals[indexPath.row].title
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("GoalCell") as! GoalTableViewCell
            
            cell.goalImageView.image = goals[indexPath.row].image
            cell.titleLable?.text = goals[indexPath.row].title
            return cell
        }
    }
    
}
