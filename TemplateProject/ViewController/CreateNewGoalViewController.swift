//
//  CreateNewGoalViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import QuartzCore

class CreateNewGoalViewController: UIViewController, UITextFieldDelegate,FloatRatingViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var linksTextField: UITextField!
    @IBOutlet weak var setGoalDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shareableSwitch: UISwitch!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    var shareWithFriends: Bool? = true
    var popViewController : PopUpViewControllerSwift!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        linksTextField.delegate = self
        let currentDate = NSDate()
        datePicker.date = currentDate
        datePicker.minimumDate = currentDate
        // Do any additional setup after loading the view.
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false

        descriptionTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        descriptionTextField.layer.borderWidth = 1
        
        // Labels init
       println(NSString(format: "%.2f", self.floatRatingView.rating) as String)
       // self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setGoalDate(sender: AnyObject) {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPad", bundle: nil)
            self.popViewController.title = "This is a popup view"
            self.popViewController.presentingVC = self
            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", withDatePicker : datePicker!, animated: true)
        } else
        {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.presentingVC = self
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", withDatePicker : datePicker!, animated: true)
                } else {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.presentingVC = self
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", withDatePicker : datePicker!, animated: true)
                }
            } else {
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                self.popViewController.title = "This is a popup view"
                self.popViewController.presentingVC = self
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", withDatePicker : datePicker!, animated: true)
            }
        }


        
    }
    @IBAction func shareableSwitched(sender: AnyObject) {
        if shareableSwitch.on {
            shareWithFriends = true
        }
        else {
            shareWithFriends = false
        }
        
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let goal = Goal()
        goal.goalDescription = descriptionTextField!.text
        goal.title = titleTextField.text
        goal.shareable = shareWithFriends!
        goal.dateGoal = datePicker.date
        goal.externalLink = linksTextField.text
        goal.starRating = 4
        goal.uploadGoal()
    }
    func textFieldShouldReturn(textField: UITextField) ->Bool {
        textField.resignFirstResponder()
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mySegue" {
            var displayGoal: DisplayGoalViewController = segue.destinationViewController as! DisplayGoalViewController
            displayGoal.titleString = titleTextField.text
            displayGoal.goalString = descriptionTextField!.text
            if(dateLabel.text != "Set Goal Date") {
                displayGoal.dateString = dateLabel.text!
            }
            displayGoal.linkString = linksTextField.text
            let dateFormat: NSDateFormatter = NSDateFormatter()
            let hello: String = dateFormat.stringFromDate(datePicker.date)
            //displayGoal.dateString = dateFormat.stringFromDate(datePicker.date)
            displayGoal.hidesBottomBarWhenPushed = true
        }
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        println(NSString(format: "%.2f", self.floatRatingView.rating) as String)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        println( NSString(format: "%.2f", self.floatRatingView.rating) as String)
    }
    func setDate(newDate: String) {
        dateLabel.text = newDate
        
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
