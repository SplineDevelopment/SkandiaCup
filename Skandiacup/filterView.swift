//
//  filterView.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 24/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class filterView: UIView, UISearchBarDelegate{
    @IBOutlet var viewGUI: filterView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("filterView", owner: self, options: nil)
        self.addSubview(viewGUI)
    }
    
    func setupSearchBar(vc: TeamsViewController){
        self.searchBar.delegate = vc
    }
}
