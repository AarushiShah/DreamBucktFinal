//
//  ScrollViewContainer.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/20/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//


import UIKit

class ScrollViewContainer: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        
        let view = super.hitTest(point, withEvent: event)
        if let theView = view {
            if theView == self {
                return scrollView
            }
        }
        
        return view
    }
    
}

 