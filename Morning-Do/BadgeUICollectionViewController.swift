//
//  BadgeUICollectionViewController.swift
//  Morning-Do
//
//  Created by Alex Pojman on 4/6/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import UIKit

class BadgeUICollectionViewController : UICollectionViewController {    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 1
        // Return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        // Return the number of items in the section
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! BadgeUICollectionViewCell
        
        // Configure the cell
        
        cell.imageView.image = UIImage(named: "logo")!
        cell.textLabel.text = "Works Fine"
        return cell
    }
}