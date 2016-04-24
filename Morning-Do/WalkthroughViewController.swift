//
//  WalkthroughViewController.swift
//  Morning-Do
//
//  Created by Alexander Pojman on 3/16/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import UIKit

class WalkthroughViewController : UIViewController {
   
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.view.sendSubviewToBack(self.testImage)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let walkthroughPageViewController = segue.destinationViewController as? WalkthroughPageViewController {
            walkthroughPageViewController.walkthroughDelegate = self
        }
    }
}

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
    
    func walkthroughPageViewController(walkthroughPageViewController: WalkthroughPageViewController,
        didUpdatePageCount count: Int) {
            pageControl.numberOfPages = count
    }
    
    func walkthroughPageViewController(walkthroughPageViewController: WalkthroughPageViewController,
        didUpdatePageIndex index: Int) {
            pageControl.currentPage = index
        
    }
    
}