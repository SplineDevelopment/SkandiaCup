//
//  matchCellView.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 16/10/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class matchCellView: UITableViewCell {
    @IBOutlet var view: UIView!


    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamGoalLabel: UILabel!
    @IBOutlet weak var homeTeamGoalLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    @IBOutlet weak var backgroundView: UIView!
    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("matchCellView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
}
