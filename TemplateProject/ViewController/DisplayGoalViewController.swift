//
//  DisplayGoalViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/17/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class DisplayGoalViewController: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var accomplishButton: UIButton!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var titleTF: UILabel?
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var link: UILabel?
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var goalDescription: UITextView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    var accomplished: Bool = false
    var liked: Bool = false
    
    var titleString: String = ""
    var goalString: String = ""
    var linkString: String = ""
    var dateString: String = ""
    var starRating: Float? = 1

    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floatRatingView.emptyImage = UIImage(named: "Star")
        self.floatRatingView.fullImage = UIImage(named: "SelectedStar")
        self.floatRatingView.editable = false
        self.floatRatingView.rating = starRating!

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
        pageImages = [UIImage(named: "bucket.png")!,
            UIImage(named: "Bucket2.png")!,
            UIImage(named: "Bucket3.png")!,
            UIImage(named: "Bucket4.png")!,
            UIImage(named: "Bucket5.png")!]
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func accomplishButtonTapped(sender: AnyObject) {
        
        if accomplished {
            accomplishButton.setImage(UIImage(named:"Pending"), forState: .Normal)
            accomplished = false

        }
        else {
            accomplishButton.setImage(UIImage(named:"Accomplished"), forState: .Normal)
            accomplished = true
        }
    }

    @IBAction func likeButtonTapped(sender: AnyObject){
        if liked {
            likeButton.setImage(UIImage(named:"Heart"), forState: .Normal)
            liked = false
            
        }
        else {
            likeButton.setImage(UIImage(named:"Heart Selected"), forState: .Normal)
            liked = true
        }

    }
    
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}