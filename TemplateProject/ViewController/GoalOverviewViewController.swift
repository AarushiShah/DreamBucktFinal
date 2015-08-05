//
//  GoalOverviewViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/27/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class GoalOverviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    var tableData = [String]()
    var goalArray = [Goal]()
    var tableImages: [String] = ["photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png"]
    
    @IBOutlet weak var starRatingLabel: UILabel!
    
    var selectedGoal = Goal()
    var displayNumber: Int? = 1
    var displayString: String? = ""
    var passOnImage: UIImage?
    var dictionaryOfImages = [Int: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starRatingLabel.text = displayString
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        ParseHelper.allPostsWithRating(displayNumber!) {
            (results: [AnyObject]?, error: NSError?) -> Void in
            let goal = results as? [Goal] ?? []
            
            if goal.count == 0  {
                let alertController = UIAlertController(title: nil, message: "No Goals in this category", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let addGoalAction = UIAlertAction(title: "Create New Goal", style: .Default) { (action) in
                    self.presentViewController(CreateNewGoalViewController(), animated: true, completion: nil)
                }
                alertController.addAction(addGoalAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            for eachgoal in goal {
                if(eachgoal.title != "") {
                    self.tableData.append(eachgoal.title!)
                }
                else {
                    self.tableData.append("No Title")
                }
                
                self.goalArray.append(eachgoal)
            }
            self.collectionView.reloadData()

        }
    }
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){}
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    //MARK: CollectionViewDelegate and Data Source
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: GoalCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GoalCell
        cell.lblCell.text = tableData[indexPath.row]
        println(goalArray[indexPath.row].imageFile)
        let image = goalArray[indexPath.row].imageFile
        if (image != nil) {
            image!.getDataInBackgroundWithBlock{
                (imageData: NSData?, error:NSError?) -> Void in
                if (error == nil) {
                    let imageUI = UIImage(data:imageData!)
                   cell.imgCell.image = imageUI
                   self.dictionaryOfImages[indexPath.row] = imageUI
                }
            }
            

        } else {
            cell.imgCell.image = UIImage(named: tableImages[indexPath.row])
            self.dictionaryOfImages[indexPath.row] = UIImage(named: tableImages[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
       selectedGoal = goalArray[indexPath.item]
        passOnImage = dictionaryOfImages[indexPath.row]
       performSegueWithIdentifier("displayGoal", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "displayGoal") {
            var displayVC: DisplayGoalViewController = segue.destinationViewController as! DisplayGoalViewController
            displayVC.titleString = selectedGoal.title!
            displayVC.goalString = selectedGoal.goalDescription!
            displayVC.starRating = selectedGoal.starRating
            displayVC.goal = selectedGoal
            displayVC.singleImage = passOnImage!
            
        }
    }
}
