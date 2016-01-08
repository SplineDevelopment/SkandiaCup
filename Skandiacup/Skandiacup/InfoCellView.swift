//
//  InfoCellView.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
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
        NSBundle.mainBundle().loadNibNamed("InfoCellView", owner: self, options: nil)
        cellView.frame = self.bounds
        self.addSubview(cellView)
        
        self.addedBackgroundView.layer.cornerRadius = 5;
        
    }
    
}