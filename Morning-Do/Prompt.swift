//
//  Prompt.swift
//  Morning-Do
//
//  Created by Alexander Pojman on 1/28/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation

class Prompt {
    let description: String
    let index: Int
    let category: String
    
    init (Description: String, Index: Int, Category: String) {
        self.description = Description
        self.index = Index
        self.category = Category
    }
}