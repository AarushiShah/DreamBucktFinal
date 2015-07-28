//
//  GoalOverviewViewController.swift
//  TemplateProject
//
//  Created by Aarushi Shah on 7/27/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class GoalOverviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    var tableData: [String] = ["Evo X", "458", "GTR", "Evo X", "458", "GTR", "Evo X", "458", "GTR", "Evo X", "458", "GTR"]
    var tableImages: [String] = ["photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png","photo1.png", "photo2.png", "photo3.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GoalCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GoalCell
        cell.lblCell.text = tableData[indexPath.row]
        cell.imgCell.image = UIImage(named: tableImages[indexPath.row])
//        cell.imgCell.layer.borderWidth = 1.0
//        cell.imgCell.layer.masksToBounds = false
//        cell.imgCell.layer.borderColor = UIColor.whiteColor().CGColor
//        cell.imgCell.clipsToBounds = true
//        cell.imgCell.layer.cornerRadius = 40
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Cell \(indexPath.row) selected")
    }

}
