//
//  CommentDisplayViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class CommentDisplayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTF: UITextField!
    
    var replies: [Comment] = []
    var refreshControl: UIRefreshControl!
    var repliesInChronoOrder: [Comment] = []
    let reply = Comment()
    var goal: Goal? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "queryOfReplies", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        
        tableView.delegate = self
        tableView.dataSource = self
        queryOfReplies()


        // Do any additional setup after loading the view.
    }
    
    func queryOfReplies() {
        let replyQueryInChronoOrder  = Comment.query()
        replyQueryInChronoOrder!.includeKey("fromUser")
        //replyQueryInChronoOrder!.includeKey("post")
        replyQueryInChronoOrder!.orderByAscending("createdAt")
        replyQueryInChronoOrder!.whereKey("toGoal", equalTo: goal!)
        replyQueryInChronoOrder!.findObjectsInBackgroundWithBlock{(result: [AnyObject]?, error: NSError?) -> Void in
            println(result!.count)
            self.repliesInChronoOrder = result as? [Comment] ?? []
            self.replies = self.repliesInChronoOrder
            let countOfReplies = self.repliesInChronoOrder.count
            //self.repliesLabel.text = "\(countOfReplies) Replies"
            self.tableView.reloadData()
        }
        self.refreshControl?.endRefreshing()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addCommentButtonClicked(sender: AnyObject) {
        println(commentTF.text)
        
            let reply = Comment()
            reply.commentString = commentTF.text
            reply.date = NSDate()
            reply.toGoal = goal
            
            
            reply.saveInBackground()
            reply.uploadReply()
        
            queryOfReplies()
    }

   

}

extension CommentDisplayViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if replies.isEmpty {
            return 0
        }
        else {
            return replies.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell") as! CommentTableViewCell
        var cellReply = replies[indexPath.row] as Comment
        cell.usernameLabel.text = cellReply.fromUser?.username!
        cell.commentContentLabel.text = cellReply.commentString
        return cell
    }
}

extension CommentDisplayViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let reply = replies[indexPath.row] as Comment
            println(self.reply)
            reply.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                self.reply.delete()
                
            })
            replies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            
        }

     }
}

