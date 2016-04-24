//
//  MDMatrix.swift
//  Morning-Do
//
//  Created by Alex Pojman on 2/3/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation

class MDMatrix {
    
    func initWithMaxX() {
        
    }
    - (id)initWithMaxX:(size_t)x MaxY:(size_t)y {
        if (self = [super init]) {
            _data = (char *) malloc(x * y);
            _max = MDSizeMake(x, y);
            [self fillWithValue:0];
        }
        return self;
    }
}