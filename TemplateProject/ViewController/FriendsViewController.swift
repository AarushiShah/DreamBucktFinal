//
//  FriendsViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/16/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
import UIKit
import Parse

class FriendsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var tableData: [String] = ["Evo X", "458", "GTR", "Evo X", "458", "GTR", "Evo X", "458", "GTR", "Evo X", "458", "GTR"]
    var tableImages: [String] = ["photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png"]
   
    // stores all the users that match the current search query
      override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println(PFUser.currentUser())
        ParseHelper.getFriendsForUser(PFUser.currentUser()!) {
            (results: [AnyObject]?, error: NSError?) -> Void in
            let user = results as? [PFUser] ?? []
                //println("Their Friends Are \(user.friends)")

            
            if let error = error {
                // Call the default error handler in case of an Error
                ErrorHandling.defaultErrorHandler(error)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FriendsCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FriendsCell
        cell.lblCell.text = tableData[indexPath.row]
        cell.imgCell.image = UIImage(named: tableImages[indexPath.row])
        cell.imgCell.layer.borderWidth = 1.0
        cell.imgCell.layer.masksToBounds = false
        cell.imgCell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.imgCell.clipsToBounds = true
        cell.imgCell.layer.cornerRadius = 40
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Cell \(indexPath.row) selected")
    }
    // MARK: Update userlist
    
    /**
    Is called as the completion block of all queries.
    As soon as a query completes, this method updates the Table View.
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//MARK: Search Bar Delegate

extension FriendsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        //state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
       // state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
       // ParseHelper.searchUsers(searchText, completionBlock:updateList)
    }
    
}
