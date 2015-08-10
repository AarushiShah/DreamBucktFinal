//
//  FriendsViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import UIKit
import Parse

class FriendsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{
    
    private let reuseIdentifier = "Cell"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var tableData = [String]()
    var userArray = [PFUser]()
    var tableImages = [UIImage]()
   
    var isSearchOn = false
    var searchResults = [String]()
    var selecteduser: PFUser!
    var listOfFriends = [AnyObject]()
    var selectedimage = UIImage?()
    
    // stores all the users that match the current search query
      override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        ParseHelper.allUsers() {
            (results: [AnyObject]?, error: NSError?) -> Void in
            let user = results as? [PFUser] ?? []
            var name: String
            self.userArray = user
            for eachuser in user {
                name = eachuser.username!
                var image: AnyObject? = eachuser["profileImage"]
                if (image != nil) {
                    let data = image!.getData()
                
                        if (data != nil) {
                                var profileImage = UIImage(data: data!, scale:1.0)
                                self.tableImages.append(profileImage!)
                        } else {
                                self.tableImages.append(UIImage(named: "User Image")!)
                        }
                } else {
                    self.tableImages.append(UIImage(named: "User Image")!)
                }
                

                
                self.tableData.append(name)
                
                self.collectionView!.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
        }
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchOn == true && !searchResults.isEmpty {
            return searchResults.count
        } else {
            return tableData.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FriendsCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FriendsCell
       
        var userName = String()
        if isSearchOn == true && !searchResults.isEmpty {
            userName = searchResults[indexPath.item]
        } else {
            userName = tableData[indexPath.item]
        }
        
        ParseHelper.isAFriend(userArray[indexPath.item], user2: PFUser.currentUser()!) {
            
            (results: [AnyObject]?,error: NSError?) -> Void in
            if (results?.count != 0) {
                cell.friendButton.setImage(UIImage(named:"Friend"), forState: .Normal)
            } else {
                cell.friendButton.setImage(UIImage(named:"Friend Add"), forState: .Normal)
            }
        }

        cell.lblCell.text = userName
        cell.imgCell.image = tableImages[indexPath.row]
        cell.imgCell.layer.borderWidth = 1.0
        cell.imgCell.layer.masksToBounds = false
        cell.imgCell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.imgCell.clipsToBounds = true
        cell.imgCell.layer.cornerRadius = 35
        cell.user = userArray[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selecteduser = userArray[indexPath.item]
        selectedimage = tableImages[indexPath.item]
        performSegueWithIdentifier("profile", sender: nil)
    }
    
    @IBAction func myProfile(sender: AnyObject) {
        let user = PFUser.currentUser() as PFUser!
        selecteduser = user
        
        var image: AnyObject? = PFUser.currentUser()?.objectForKey("profileImage")
        if (image != nil) {
            let data = image!.getData()
            
            if (data != nil) {
                var profileImage = UIImage(data: data!, scale:1.0)
                selectedimage = profileImage
            } else {
                selectedimage = (UIImage(named: "User Image")!)
            }
        } else {
             selectedimage = (UIImage(named: "User Image")!)
    }

        
        //selectedimage = user["profileImage"] as? UIImage
        performSegueWithIdentifier("profile", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var profileVC: ProfileViewController = segue.destinationViewController as! ProfileViewController
        profileVC.user = selecteduser
        profileVC.profileImage = selectedimage
    }
    
    //MARK: Search Bar Delegate
    
    // This function is fired when the user tap the Search Bar's Cancel button
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil // Clear out the Search Bar's text field
        searchBar.showsCancelButton = false // Hide the Search Bar's Cancel button
        searchBar.resignFirstResponder()  // Dismiss the keyboard
        isSearchOn = false // Turn off search function
        self.collectionView.reloadData()  // Refresh the collection view
    }
    
    // this function is fired when the user start entering text in the Search Bar's text field
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true  // Show the Search Bar's Cancel button
        if !searchText.isEmpty {
            isSearchOn = true  // Turn on searching function
            self.filterContentForSearchText() // Search the collection view's dataSource
            self.collectionView.reloadData()
        }
    }
    
    func filterContentForSearchText() {
        // Remove all elements from the searchResults array
        searchResults.removeAll(keepCapacity: false)
        
        // Loop throught the collection view's dataSource object
        for imageFileName in tableData {
            let stringToLookFor = imageFileName as NSString
            let sourceString = searchBar.text as NSString
            
            if stringToLookFor.localizedCaseInsensitiveContainsString(sourceString as String) {
                // Match found, so add it to the searchResults array variable
                searchResults.append(imageFileName)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


