//
//  CategoriesTableViewController.swift
//  Morning-Do
//
//  Created by Alex Pojman on 2/3/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import UIKit

class CategoriesTableViewController : UITableViewController {
    
    let rootRef     =   Firebase(url: "https://morning-do.firebaseio.com")
    let awardRef    =   Firebase(url: "https://morning-do.firebaseio.com/awards")
    let promptsRef  =   Firebase(url: "https://morning-do.firebaseio.com/prompts")
    let userRef     =   Firebase(url: "https://morning-do.firebaseio.com/users/")
    var categoriesRef = Firebase()
    
    let categoryImages = [
        "brainpower.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png",
        "family.png"]
    
    var numberOfCategories : Int = 0
    var categories = [String?]()
    var selectedCategories = [String:Bool]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        promptsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for (category) in snapshot.children {
                self.categories.append(category.key)
                
            }
            self.numberOfCategories = Int(snapshot.childrenCount) // Number of Categories
            for (category) in self.categories {
                self.selectedCategories[category!] = false
            }
            self.tableView.reloadData()
            
        })
        
        // Test code getting user selected categories
        
        self.categoriesRef = Firebase(url: "https://morning-do.firebaseio.com/users/" + self.rootRef.authData.uid + "/categories")
        self.categoriesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for categoryChild in snapshot.children.allObjects as! [FDataSnapshot] {
                self.selectedCategories[categoryChild.key] = categoryChild.value as? Bool
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Set Nav Bar Attributes
        //self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "CrackerJack-Regular", size: 32)!]
        //
        self.title = "Select Categories".uppercaseString
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCategories
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell") as! CategoriesTableViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = bgColorView
        
        cell.label.text = self.categories[indexPath.row]
        
        
        if (self.selectedCategories[(cell.label.text)!]! == false) {
            cell.enabledImage.alpha = 0.0
        } else if (self.selectedCategories[(cell.label.text)!]! == true) {
            cell.enabledImage.alpha = 1.0
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CategoriesTableViewCell
        
        let selectedCategory = self.categories[indexPath.row]!
        
        if let currentCategoryEnabled = self.selectedCategories[selectedCategory] {
            self.selectedCategories[selectedCategory] = !currentCategoryEnabled
            
            self.categoriesRef.updateChildValues([selectedCategory: self.selectedCategories[selectedCategory]!])
        }
        
        // This value is now true
        if (self.selectedCategories[selectedCategory] == true) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                cell.enabledImage.alpha = 1.0
                
                }, completion: { (finished: Bool) -> Void in
                    
            })
        } else if (self.selectedCategories[selectedCategory] == false) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                cell.enabledImage.alpha = 0.0
                
                }, completion: { (finished: Bool) -> Void in
                    
            })
        }
        
    }
}