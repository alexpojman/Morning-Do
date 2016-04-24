//
//  WalkThroughPageViewController.swift
//  Morning-Do
//
//  Created by Alexander Pojman on 3/16/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation
import UIKit

class WalkthroughPageViewController: UIPageViewController {
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        }
        
        walkthroughDelegate?.walkthroughPageViewController(self,
            didUpdatePageCount: orderedViewControllers.count - 1)
        
    }
}

private(set) var orderedViewControllers: [UIViewController] = {
    return [newColoredViewController("First"),
        newColoredViewController("Second"),
        newColoredViewController("Third"),
        newColoredViewController("Login")]
}()

private func newColoredViewController(color: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil) .
        instantiateViewControllerWithIdentifier("\(color)VC")
}


extension WalkthroughPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if let firstViewController = viewControllers?.first,
                let index = orderedViewControllers.indexOf(firstViewController) {
                    walkthroughDelegate?.walkthroughPageViewController(self,
                        didUpdatePageIndex: index)
            }
    }
    
}

// MARK: UIPageViewControllerDataSource

extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
}

// To be referenced in WalkthroughViewController.swift
protocol WalkthroughPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func walkthroughPageViewController(walkthroughPageViewController: WalkthroughPageViewController,
        didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func walkthroughPageViewController(walkthroughPageViewController: WalkthroughPageViewController,
        didUpdatePageIndex index: Int)
    
}
