//
//  InfoCellView.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 15/12/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class InfoCellView: UITableViewCell {
    @IBOutlet var cellView: UIView!
    
    @IBOutlet weak var bodyText: UITextView!
    
    @IBOutlet weak var addedBackgroundView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)!
        self.commonInit()        
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("newsCellView", owner: self, options: nil)
        cellView.frame = self.bounds
        self.addSubview(cellView)
        
        self.addedBackgroundView.layer.cornerRadius = 5;
        
    }
    
}