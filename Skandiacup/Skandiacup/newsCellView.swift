//
//  newsView.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 29/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class newsCellView: UITableViewCell {
    @IBOutlet var cellView: UIView!
    
    @IBOutlet weak var bodyText: UITextView!

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
    }

}
