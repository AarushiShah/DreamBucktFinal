//
//  CreateNewGoalViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import QuartzCore
import Mixpanel

class CreateNewGoalViewController: UIViewController, UITextFieldDelegate,FloatRatingViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var linksTextField: UITextField!
    @IBOutlet weak var setGoalDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!

    var popViewController : PopUpViewControllerSwift!
    var goalRating: Float? = 1
    var photoTakingHelper:PhotoTakingHelper?
    var proceed: Bool = false
    var finalGoal = Goal()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.hidden = true
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: "tappedView:")
        imageView.addGestureRecognizer(tapRec)
        imageView.userInteractionEnabled = true

        titleTextField.delegate = self
        linksTextField.delegate = self
        let currentDate = NSDate()
        datePicker.date = currentDate
        datePicker.minimumDate = currentDate
        
        // Do any additional setup after loading the view.
        self.floatRatingView.emptyImage = UIImage(named: "Star")
        self.floatRatingView.fullImage = UIImage(named: "SelectedStar")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 1
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = false
        self.floatRatingView.floatRatings = false

        descriptionTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        descriptionTextField.layer.borderWidth = 1
        
        // Labels init
       goalRating = self.floatRatingView.rating
       println(goalRating)
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        if (imageView.image != nil) {
            let goal = Goal()
            goal.goalDescription = descriptionTextField!.text
            goal.title = titleTextField.text
            goal.shareable = true
            goal.dateGoal = datePicker.date
            goal.externalLink = linksTextField.text
            goal.starRating = goalRating!
            goal.accomplished = false
            goal.image = imageView.image
            finalGoal = goal
            performSegueWithIdentifier("mySegue", sender: nil)
            goal.uploadGoal()
            
            Mixpanel.sharedInstanceWithToken("46ebc5702d4346b9a6b91b32153cd1bc")
            let mixpanel: Mixpanel = Mixpanel.sharedInstance()
            mixpanel.track("Goal Created", properties:["StarRating" : goalRating!])
        } else {
            proceed = false
            let alertController = UIAlertController(title: nil, message: "Please Add an Image", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)

        }
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
                displayGoal.starRating = goalRating
                displayGoal.goal = finalGoal
                if(dateLabel.text != "Set Goal Date") {
                    displayGoal.dateString = dateLabel.text!
                }
                displayGoal.linkString = linksTextField.text
                displayGoal.singleImage = imageView.image!
                let dateFormat: NSDateFormatter = NSDateFormatter()
                let hello: String = dateFormat.stringFromDate(datePicker.date)
                displayGoal.hidesBottomBarWhenPushed = true
            }
        
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        goalRating = self.floatRatingView.rating
        println(goalRating)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        goalRating = self.floatRatingView.rating
        println(goalRating)
    }
    func setDate(newDate: String) {
        dateLabel.text = newDate
        
    }
    func tappedView(sender:UITapGestureRecognizer) {
        photoTakingHelper = PhotoTakingHelper(viewController: self) { (image: UIImage?) in
            
            self.imageView.image = image
         }
        
    }

}
