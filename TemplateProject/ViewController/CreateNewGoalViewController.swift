//
//  CreateNewGoalViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class CreateNewGoalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField?
    @IBOutlet weak var linksTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var shareableSwitch: UISwitch!
    
    var shareWithFriends: Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        descriptionTextField!.delegate = self
        linksTextField.delegate = self
        let currentDate = NSDate()
        datePicker.date = currentDate
        datePicker.minimumDate = currentDate
        // Do any additional setup after loading the view.
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
            displayGoal.linkString = linksTextField.text
            let dateFormat: NSDateFormatter = NSDateFormatter()
            let hello: String = dateFormat.stringFromDate(datePicker.date)
            displayGoal.dateString = dateFormat.stringFromDate(datePicker.date)
            displayGoal.hidesBottomBarWhenPushed = true
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
