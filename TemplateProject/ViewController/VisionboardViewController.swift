//
//  VisionboardViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class VisionboardViewController: UIViewController {

    var photoTakingHelper:PhotoTakingHelper?
    var textBox: UITextField?
    var collagePictures: [UIImageView] = []
    var collageTextBoxes: [UITextField] = []
    var numberClicked: Int = 0
  //  var collageObjects: [AnyObject] = []
    
    @IBOutlet weak var paint: UIBarButtonItem!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var visionboardImageView: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var paintToolBar: UIToolbar!
    @IBOutlet weak var colorWheel: ColorWheel!
    @IBOutlet weak var createNew: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var existingUser = PFUser.currentUser()
        if let userImageFile = existingUser!["visionboardImage"] as? PFFile {
            
            userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
                //if error != nil {
                    let image = UIImage(data:imageData!)
                    self.visionboardImageView.image = image
                    self.paintToolBar.hidden = true
                
               // }
            }
        } else {
            editButton.hidden = true
            paintToolBar.hidden = false
            visionboardImageView.hidden = true
            createNew.hidden = true
        }
        
        colorWheel.hidden = true
        colorWheel.userInteractionEnabled = true
        colorWheel.multipleTouchEnabled = true

        
        
        let dragRec = UIPanGestureRecognizer()
        dragRec.addTarget(self, action: "draggedView:")
        colorWheel.addGestureRecognizer(dragRec)
        
        

        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        

    }
    
    @IBAction func editVisionboard(sender: AnyObject) {
        editButton.hidden = true
        paintToolBar.hidden = false
        createNew.hidden = true
        visionboardImageView.userInteractionEnabled = true

    }
    @IBAction func createNewVisionboard(sender: AnyObject) {
        editButton.hidden = true
        createNew.hidden = true
        visionboardImageView.hidden = true
        paintToolBar.hidden = false
        view.backgroundColor = UIColor.whiteColor()
        eraseEverything()
    }

    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        colorWheel.hidden = true
        numberClicked++
    }
    @IBAction func paintButton(sender: AnyObject){
        if numberClicked % 2 == 0 {
            colorWheel.hidden = false
        } else {
            colorWheel.hidden = true
        }
        numberClicked++
    }
    @IBAction func handleTapGesture(gesture: UITapGestureRecognizer) {
        var point = gesture.locationInView(colorWheel)
        self.container.backgroundColor = colorWheel.colorAtPoint(point)
        //self.container!.backgroundColor = colorWheel.colorAtPoint(point)
    }
    @IBAction func addPicture(sender: AnyObject) {
        photoTakingHelper = PhotoTakingHelper(viewController: self) { (image: UIImage?) in
            // don't do anything, yet...
            var imageViewObject: UIImageView?
            imageViewObject = UIImageView(frame:CGRectMake(100, 150, 200, 200));
            imageViewObject!.image = image
            
            
            imageViewObject!.userInteractionEnabled = true
            imageViewObject!.multipleTouchEnabled = true
            
            self.addGestures(imageViewObject!)
            
            self.container!.addSubview(imageViewObject!)
            self.container!.bringSubviewToFront(imageViewObject!)
            
            self.collagePictures.append(imageViewObject!)
           // self.collageObjects.append(imageViewObject!)

        }
        

    }
    @IBAction func trashButtonClicked(sender: AnyObject) {
        if (collagePictures.count != 0) {
           collagePictures[collagePictures.count - 1].hidden = true
           collagePictures.removeLast()
        }
        
    }
    @IBAction func takeScreenShot(sender: AnyObject) {
        var screenshot = takeScreenshot(self.container!) // change for the imageView
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        
        let alert = UIAlertView()
        //alert.title = "Visionboard Saved"
        alert.message = "Collage saved to Photo Library!"
        alert.addButtonWithTitle("Ok")
        alert.show()
        //view.userInteractionEnabled = false
       
        self.visionboardImageView.image = screenshot
        visionboardImageView.hidden = false
        self.paintToolBar.hidden = true
        self.editButton.hidden = false
        createNew.hidden = false
        eraseEverything()
    }
    
    func eraseEverything() {
        
        for each in collagePictures {
            each.removeFromSuperview()
            collagePictures.removeLast()
        }
        
        for each in collageTextBoxes {
            each.removeFromSuperview()
            collageTextBoxes.removeLast()
        }
    }
    func takeScreenshot(currentView: UIView) -> UIImage{
        paintToolBar.hidden = true
        editButton.hidden = true
        createNew.hidden = true
        colorWheel.hidden = true
        UIGraphicsBeginImageContextWithOptions(currentView.bounds.size, true, 0.0)
        currentView.drawViewHierarchyInRect(currentView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var newUser = PFUser.currentUser()
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(data: imageData)
        newUser!.setObject(imageFile, forKey: "visionboardImage")
        newUser!.saveInBackground()
        
        return image

    }
    @IBAction func addTextField(sender: AnyObject) {
        var textBoxObject:UITextField?
        textBoxObject = UITextField(frame:CGRectMake(50, 150, 300, 50))
        self.addGestures(textBoxObject!)
        textBoxObject?.backgroundColor = UIColor.redColor()
        self.container!.addSubview(textBoxObject!)
        // textBoxObject!.delegate = self
        self.collageTextBoxes.append(textBoxObject!)
       // self.collageObjects.append(textBoxObject!)

    }

    func draggedView(recognizer:UIPanGestureRecognizer){
        //self.view.bringSubviewToFront(recognizer.view!)
        var translation = recognizer.translationInView(self.view!)
        recognizer.view!.center = CGPointMake(recognizer.view!.center.x + translation.x, recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
        
    }
    func pinchedView(sender:UIPinchGestureRecognizer){
        self.view!.bringSubviewToFront(sender.view!)
        sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1.0
        
    }
    func rotatedView(sender:UIRotationGestureRecognizer){
        var lastRotation = CGFloat()
        self.view!.bringSubviewToFront(sender.view!)
        if(sender.state == UIGestureRecognizerState.Ended){
            lastRotation = 0.0;
        }
        var rotation = 0.0 - (lastRotation - sender.rotation)
        // var point = rotateRec.locationInView(sender.view!)
        var currentTrans = sender.view!.transform
        var newTrans = CGAffineTransformRotate(currentTrans, rotation)
        
        sender.view!.transform = newTrans
        lastRotation = sender.rotation
        
    }
    func tappedView(sender:UITapGestureRecognizer) {
        println("tappedd")
    }
    func addGestures(object:AnyObject) {
        
        
        let dragRec = UIPanGestureRecognizer()
        let pinchRec = UIPinchGestureRecognizer()
        let rotateRec = UIRotationGestureRecognizer()
        let tapRec = UITapGestureRecognizer()
        
        dragRec.addTarget(self, action: "draggedView:")
        pinchRec.addTarget(self, action: "pinchedView:")
        rotateRec.addTarget(self, action: "rotatedView:")
        tapRec.addTarget(self, action: "tappedView:")
        
        
        object.addGestureRecognizer(dragRec)
        object.addGestureRecognizer(pinchRec)
        object.addGestureRecognizer(rotateRec)
        object.addGestureRecognizer(tapRec)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    
}

