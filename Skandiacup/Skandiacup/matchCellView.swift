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
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamGoalLabel: UILabel!
    @IBOutlet weak var homeTeamGoalLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noUpcommingMatchesLabel: UILabel!
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
        self.innerView.layer.cornerRadius = 10
//        self.dateView.backgroundColor = UIColor(red:0.02, green:0.59, blue:1, alpha:1)
        self.view.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    }
}
