//
//  DisplayGoalViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import Bond

class DisplayGoalViewController: UIViewController, UIScrollViewDelegate {

    var likeBond: Bond<[PFUser]?>!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var accomplishButton: UIButton!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var titleTF: UILabel?
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var likesLabel: UIButton!
    @IBOutlet weak var link: UILabel?
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var goalDescription: UITextView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    var accomplished: Bool = false
    var liked: Bool = false
    var numOfLikes: Int = 0
    var goal:Goal? {
        didSet {
            if let goal = goal {
                // bind the likeBond that we defined earlier, to update like label and button when likes change
                if let likeButton = likeButton {
                    goal.likes ->> likeBond
                }
            }
        }
    }
    var titleString: String = ""
    var goalString: String = ""
    var linkString: String = ""
    var dateString: String = ""
    var starRating: Float? = 1

    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    var singleImage: UIImage = UIImage()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 1
        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
            // 2
            if let likeList = likeList {
                
                self.likesLabel.setTitle(MethodHelper.stringFromUserList(likeList), forState: .Normal)
 
                self.likeButton.selected = contains(likeList, PFUser.currentUser()!)
                
            } else {
                self.likesLabel.setTitle("0", forState: .Normal)
                self.likeButton.selected = false
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (goal?.accomplished == true) {
            accomplishButton.setImage(UIImage(named:"Accomplished"), forState: .Normal)
            accomplished = true
            accomplishButton.userInteractionEnabled = false
            
        }
        
        if (singleImage != UIImage()) {
                pageImages.append(singleImage)
        }
           
        goalDescription.userInteractionEnabled = false
        
        self.floatRatingView.emptyImage = UIImage(named: "Star")
        self.floatRatingView.fullImage = UIImage(named: "SelectedStar")
        self.floatRatingView.editable = false
        self.floatRatingView.rating = starRating!
        
        if let goal = goal {
            //numOfLikes = goal.fetchLikes()
            self.likesLabel.setTitle("\(numOfLikes)", forState: .Normal)

        }
        else {
            self.likesLabel.setTitle("0", forState: .Normal)
        }

        whiteView.layer.cornerRadius = 5
        scrollView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        if (titleString != "") {
             titleTF!.text = titleString
        }
        if (goalString != "") {
            goalDescription?.text = goalString
        }
        if (linkString != "") {
            link?.text = linkString
        }
        if (dateString != "") {
            date!.text = dateString
        }
        // 1
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        
        let pageCount = pageImages.count
        
        // 2
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
    }
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            
            // 4
            pageViews[page] = newPageView
        }
    }
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    @IBAction func accomplishButtonTapped(sender: AnyObject) {
        
        if accomplished {
            accomplishButton.setImage(UIImage(named:"Pending"), forState: .Normal)
            accomplished = false
             goal?.updateAccomplish(false)

        }
        else {
            accomplishButton.setImage(UIImage(named:"Accomplished"), forState: .Normal)
            accomplished = true
            accomplishButton.userInteractionEnabled = false
            performSegueWithIdentifier("Accomplished", sender: self)
            goal?.updateAccomplish(true)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Accomplished") {
            
            var accomplishedGoal: AccomplishedGoalViewController = segue.destinationViewController as! AccomplishedGoalViewController
            accomplishedGoal.goal = self.goal
        }
    }


    @IBAction func likeButtonTapped(sender: AnyObject){
        
        goal?.toggleLikePost(PFUser.currentUser()!)

    }
    
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}