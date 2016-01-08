//
//  newsView.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import UIKit

class newsCellView: UITableViewCell {
    @IBOutlet var cellView: UIView!
    
    @IBOutlet weak var bodyText: UITextView!

    @IBOutlet weak var addedBackgroundView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
//    override init(frame: CGRect) { // for using CustomView in code
//        super.init(frame: frame)
//        self.commonInit()
//    }
    
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
