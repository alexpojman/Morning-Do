//
//  BadgeUICollectionViewCell.swift
//  
//
//  Created by Alex Pojman on 4/6/16.
//
//

import Foundation
import UIKit

class BadgeUICollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}