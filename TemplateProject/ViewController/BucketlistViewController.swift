//
//  BucketlistViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class BucketlistViewController: UIViewController {
    
    var selectedStar: Int? = 1
    var selectedStarString: String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonOne(sender: AnyObject) {
        selectedStar = 1
        selectedStarString = "One Star Dreams"
        performSegueWithIdentifier("goalOverview", sender: nil)
    }
    @IBAction func buttonTwo(sender: AnyObject) {
        selectedStar = 2
         selectedStarString = "Two Star Dreams"
        performSegueWithIdentifier("goalOverview", sender: nil)
    }
    @IBAction func buttonThree(sender: AnyObject) {
        selectedStar = 3
         selectedStarString = "Three Star Dreams"
        performSegueWithIdentifier("goalOverview", sender: nil)
    }
    
    @IBAction func buttonFour(sender: AnyObject) {
        selectedStar = 4
         selectedStarString = "Four Star Dreams"
        performSegueWithIdentifier("goalOverview", sender: nil)
    }
    
    @IBAction func buttonFive(sender: AnyObject) {
        selectedStar = 5
         selectedStarString = "Five Star Dreams"
        performSegueWithIdentifier("goalOverview", sender: nil)
    }
    
    //MARK: Segues
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goalOverview") {
            var goalVC: GoalOverviewViewController = segue.destinationViewController as! GoalOverviewViewController
            goalVC.displayNumber = selectedStar
            goalVC.displayString = selectedStarString
        }
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
