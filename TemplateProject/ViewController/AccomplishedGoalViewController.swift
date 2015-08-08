//
//  AccomplishedGoalViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/31/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Mixpanel

class AccomplishedGoalViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var shareableSwitch: UISwitch!
    
    var goal: Goal?
    var photoTakingHelper:PhotoTakingHelper?
    var shareWithFriends = true
    var uploadingImage: UIImage?

    @IBOutlet var pageControl: UIPageControl!
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEmptyImages()
        reloadScrollView()
        
       Mixpanel.sharedInstanceWithToken("46ebc5702d4346b9a6b91b32153cd1bc")
       let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Goal Accomplished")


    }
        @IBAction func shareableSwitched(sender: AnyObject) {
            if shareableSwitch.on {
                shareWithFriends = true
            }
            else {
                shareWithFriends = false
            }
            
        }
    @IBAction func backPressed(sender: AnyObject)
    {
        if (uploadingImage != nil) {
           println(pageImages)
           goal?.updateImages(uploadingImage!)
           goal!.updateShareable(shareWithFriends)
        
           self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alertController = UIAlertController(title: nil, message: "Please Add an Image", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)

        }
            
        
    }
    func reloadScrollView() {
        
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
    func addEmptyImages() {
        for var index = 0; index < 1; ++index {
            var emptyImage = UIImage()
            pageImages.append(emptyImage)
        
        }
        
    }
    func tappedView(sender:UITapGestureRecognizer) {
        photoTakingHelper = PhotoTakingHelper(viewController: self) { (image: UIImage?) in
           var currentPage = self.pageControl.currentPage
           self.pageImages[currentPage] = image!
          self.uploadingImage = image
            self.reloadScrollView()
        }

    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
//        if let pageView = pageViews[page] {
//            // Do nothing. The view is already loaded.
//        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.userInteractionEnabled = true
            let tapRec = UITapGestureRecognizer()
            tapRec.addTarget(self, action: "tappedView:")
            newPageView.addGestureRecognizer(tapRec)
            newPageView.backgroundColor = UIColor.blackColor()

            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
//        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
