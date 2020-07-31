//
//  Cell.swift
//  GameOfLife
//
//  Created by Elizabeth Wingate on 7/30/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

//Cell model
class Cell {
    
    let x: Int //x cell (if its positive, neg or 0)
    let y: Int //y cell (^)
    var state: Bool // if x or y cells are alive
    var gridView: UIView! //game view
    var live: Bool // did it live yes or no
    
    // initing everything
    init (x: Int, y: Int, state: Bool) {
        self.x = x
        self.y = y
        self.state = state
        self.gridView = UIView()
        self.live = false
    }
}
